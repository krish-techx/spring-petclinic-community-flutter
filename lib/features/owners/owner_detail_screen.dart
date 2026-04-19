import 'package:flutter/material.dart';

import '../../shared/widgets/confirmation_dialog.dart';
import '../pets/pet.dart';
import '../pets/pet_form_screen.dart';
import '../pets/pet_service.dart';
import '../visits/visit.dart';
import '../visits/visit_form_screen.dart';
import '../visits/visit_service.dart';
import 'owner.dart';
import 'owner_form_screen.dart';
import 'owner_service.dart';

class OwnerDetailScreen extends StatefulWidget {
  const OwnerDetailScreen({super.key, required this.ownerId});

  final int ownerId;

  @override
  State<OwnerDetailScreen> createState() => _OwnerDetailScreenState();
}

class _OwnerDetailScreenState extends State<OwnerDetailScreen> {
  final OwnerService _ownerService = OwnerService();
  final PetService _petService = PetService();
  final VisitService _visitService = VisitService();

  bool _isLoading = true;
  String? _errorMessage;
  Owner? _owner;

  @override
  void initState() {
    super.initState();
    _loadOwner();
  }

  Future<void> _loadOwner() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final owner = await _ownerService.getOwner(widget.ownerId);
      if (!mounted) {
        return;
      }
      setState(() {
        _owner = owner;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openOwnerForm() async {
    if (_owner == null) {
      return;
    }

    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => OwnerFormScreen(owner: _owner)),
    );

    if (changed == true) {
      await _loadOwner();
    }
  }

  Future<void> _deleteOwner() async {
    final owner = _owner;
    if (owner?.id == null) {
      return;
    }

    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete owner?',
      message:
          'Delete ${owner!.fullName} and all associated pets and visits? This action cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (!confirmed) {
      return;
    }
    if (!mounted) {
      return;
    }

    try {
      final messenger = ScaffoldMessenger.of(context);
      await _ownerService.deleteOwner(owner.id!);
      if (!mounted) {
        return;
      }
      messenger.showSnackBar(
        SnackBar(content: Text('${owner.fullName} deleted.')),
      );
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _openPetForm({int? petId}) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => PetFormScreen(
          ownerId: petId == null ? _owner?.id : null,
          petId: petId,
        ),
      ),
    );

    if (changed == true) {
      await _loadOwner();
    }
  }

  Future<void> _openVisitForm({int? visitId, int? petId}) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => VisitFormScreen(petId: petId, visitId: visitId),
      ),
    );

    if (changed == true) {
      await _loadOwner();
    }
  }

  Future<void> _deletePet(Pet pet) async {
    if (pet.id == null) {
      return;
    }

    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete pet?',
      message: 'Delete ${pet.name} and all associated visits?',
      confirmLabel: 'Delete',
    );
    if (!confirmed) {
      return;
    }

    try {
      await _petService.deletePet(pet.id!);
      await _loadOwner();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${pet.name} deleted.')));
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _deleteVisit(Visit visit) async {
    if (visit.id == null) {
      return;
    }

    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete visit?',
      message: 'Delete the visit on ${visit.date}?',
      confirmLabel: 'Delete',
    );
    if (!confirmed) {
      return;
    }

    try {
      await _visitService.deleteVisit(visit.id!);
      await _loadOwner();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Visit deleted.')));
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final owner = _owner;

    return Scaffold(
      appBar: AppBar(title: const Text('Owner Details')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_errorMessage!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _loadOwner,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          : owner == null
          ? const Center(child: Text('Owner not found.'))
          : RefreshIndicator(
              onRefresh: _loadOwner,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            owner.fullName,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 12),
                          _DetailRow(label: 'Address', value: owner.address),
                          _DetailRow(label: 'City', value: owner.city),
                          _DetailRow(
                            label: 'Telephone',
                            value: owner.telephone,
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              FilledButton.tonalIcon(
                                onPressed: _openOwnerForm,
                                icon: const Icon(Icons.edit_outlined),
                                label: const Text('Edit Owner'),
                              ),
                              FilledButton.tonalIcon(
                                onPressed: _deleteOwner,
                                icon: const Icon(Icons.delete_outline),
                                label: const Text('Delete Owner'),
                              ),
                              FilledButton.icon(
                                onPressed: () => _openPetForm(),
                                icon: const Icon(Icons.add),
                                label: const Text('Add Pet'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pets and Visits',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  if (owner.pets.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No pets registered for this owner.'),
                      ),
                    )
                  else
                    for (final pet in owner.pets)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pet.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                _DetailRow(
                                  label: 'Birth Date',
                                  value: pet.birthDate,
                                ),
                                _DetailRow(label: 'Type', value: pet.type.name),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: [
                                    FilledButton.tonalIcon(
                                      onPressed: () =>
                                          _openPetForm(petId: pet.id),
                                      icon: const Icon(Icons.edit_outlined),
                                      label: const Text('Edit Pet'),
                                    ),
                                    FilledButton.tonalIcon(
                                      onPressed: () => _deletePet(pet),
                                      icon: const Icon(Icons.delete_outline),
                                      label: const Text('Delete Pet'),
                                    ),
                                    FilledButton.icon(
                                      onPressed: () =>
                                          _openVisitForm(petId: pet.id),
                                      icon: const Icon(Icons.add),
                                      label: const Text('Add Visit'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Visits',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 8),
                                if (pet.visits.isEmpty)
                                  const Text('No visits registered.')
                                else
                                  for (final visit in pet.visits)
                                    Card.outlined(
                                      child: ListTile(
                                        title: Text(visit.description),
                                        subtitle: Text(visit.date),
                                        trailing: Wrap(
                                          spacing: 4,
                                          children: [
                                            IconButton(
                                              onPressed: () => _openVisitForm(
                                                visitId: visit.id,
                                              ),
                                              icon: const Icon(
                                                Icons.edit_outlined,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                  _deleteVisit(visit),
                                              icon: const Icon(
                                                Icons.delete_outline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(label, style: Theme.of(context).textTheme.labelLarge),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
