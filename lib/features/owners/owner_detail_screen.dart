/*
 * Copyright 2002-2017 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';

import '../../shared/theme/classic_theme.dart';
import '../../shared/widgets/confirmation_dialog.dart';
import '../../shared/widgets/classic_scaffold.dart';
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

    return ClassicScaffold(
      section: ClassicSection.owners,
      title: 'Owner Information',
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
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                children: [
                  _OwnerInfoTable(owner: owner),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Back'),
                      ),
                      FilledButton(
                        onPressed: _openOwnerForm,
                        child: const Text('Edit Owner'),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: ClassicPalette.accent,
                          foregroundColor: Colors.white,
                          side: BorderSide.none,
                        ),
                        onPressed: () => _openPetForm(),
                        child: const Text('Add New Pet'),
                      ),
                      OutlinedButton(
                        onPressed: _deleteOwner,
                        child: const Text('Delete Owner'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Pets and Visits',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  if (owner.pets.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('No pets registered for this owner.'),
                    )
                  else
                    for (final pet in owner.pets)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _PetAndVisitsSection(
                          pet: pet,
                          onEditPet: () => _openPetForm(petId: pet.id),
                          onDeletePet: () => _deletePet(pet),
                          onAddVisit: () => _openVisitForm(petId: pet.id),
                          onEditVisit: (visit) =>
                              _openVisitForm(visitId: visit.id),
                          onDeleteVisit: _deleteVisit,
                        ),
                      ),
                ],
              ),
            ),
    );
  }
}

class _OwnerInfoTable extends StatelessWidget {
  const _OwnerInfoTable({required this.owner});

  final Owner owner;

  @override
  Widget build(BuildContext context) {
    return _ClassicInfoTable(
      rows: [
        _InfoRow(
          label: 'Name',
          value: Text(
            owner.fullName,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        _InfoRow(label: 'Address', value: Text(owner.address)),
        _InfoRow(label: 'City', value: Text(owner.city)),
        _InfoRow(label: 'Telephone', value: Text(owner.telephone)),
      ],
    );
  }
}

class _PetAndVisitsSection extends StatelessWidget {
  const _PetAndVisitsSection({
    required this.pet,
    required this.onEditPet,
    required this.onDeletePet,
    required this.onAddVisit,
    required this.onEditVisit,
    required this.onDeleteVisit,
  });

  final Pet pet;
  final VoidCallback onEditPet;
  final VoidCallback onDeletePet;
  final VoidCallback onAddVisit;
  final ValueChanged<Visit> onEditVisit;
  final ValueChanged<Visit> onDeleteVisit;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: ClassicPalette.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 860;
            final infoPanel = _PetInfoPanel(
              pet: pet,
              onEditPet: onEditPet,
              onDeletePet: onDeletePet,
              onAddVisit: onAddVisit,
            );
            final visitsPanel = _VisitsPanel(
              visits: pet.visits,
              onEditVisit: onEditVisit,
              onDeleteVisit: onDeleteVisit,
            );

            if (!wide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [infoPanel, const SizedBox(height: 16), visitsPanel],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: infoPanel),
                const SizedBox(width: 18),
                Expanded(flex: 6, child: visitsPanel),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PetInfoPanel extends StatelessWidget {
  const _PetInfoPanel({
    required this.pet,
    required this.onEditPet,
    required this.onDeletePet,
    required this.onAddVisit,
  });

  final Pet pet;
  final VoidCallback onEditPet;
  final VoidCallback onDeletePet;
  final VoidCallback onAddVisit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ClassicInfoTable(
          rows: [
            _InfoRow(label: 'Name', value: Text(pet.name)),
            _InfoRow(label: 'Birth Date', value: Text(pet.birthDate)),
            _InfoRow(label: 'Type', value: Text(pet.type.name)),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton(onPressed: onEditPet, child: const Text('Edit Pet')),
            OutlinedButton(
              onPressed: onDeletePet,
              child: const Text('Delete Pet'),
            ),
            OutlinedButton(
              onPressed: onAddVisit,
              child: const Text('Add Visit'),
            ),
          ],
        ),
      ],
    );
  }
}

class _VisitsPanel extends StatelessWidget {
  const _VisitsPanel({
    required this.visits,
    required this.onEditVisit,
    required this.onDeleteVisit,
  });

  final List<Visit> visits;
  final ValueChanged<Visit> onEditVisit;
  final ValueChanged<Visit> onDeleteVisit;

  @override
  Widget build(BuildContext context) {
    if (visits.isEmpty) {
      return const Text('No visits registered.');
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 420),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: ClassicPalette.border),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(1.7),
              1: FlexColumnWidth(2.2),
              2: FlexColumnWidth(1.8),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: const BoxDecoration(
                  color: ClassicPalette.tableHeader,
                ),
                children: const [
                  _HeaderCell('Visit Date'),
                  _HeaderCell('Description'),
                  _HeaderCell('Actions'),
                ],
              ),
              for (var index = 0; index < visits.length; index++)
                TableRow(
                  decoration: BoxDecoration(
                    color: index.isEven
                        ? Colors.white
                        : const Color(0xFFF8F8F8),
                    border: const Border(
                      bottom: BorderSide(color: ClassicPalette.border),
                    ),
                  ),
                  children: [
                    _DataCellText(visits[index].date),
                    _DataCellText(visits[index].description),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton(
                            onPressed: () => onEditVisit(visits[index]),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            child: const Text('Edit'),
                          ),
                          OutlinedButton(
                            onPressed: () => onDeleteVisit(visits[index]),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClassicInfoTable extends StatelessWidget {
  const _ClassicInfoTable({required this.rows});

  final List<_InfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: ClassicPalette.border),
      ),
      child: Table(
        columnWidths: const {0: FixedColumnWidth(140), 1: FlexColumnWidth()},
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          for (var index = 0; index < rows.length; index++)
            TableRow(
              decoration: BoxDecoration(
                color: index.isEven ? const Color(0xFFF8F8F8) : Colors.white,
                border: const Border(
                  bottom: BorderSide(color: ClassicPalette.border),
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Text(
                    rows[index].label,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: rows[index].value,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _InfoRow {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final Widget value;
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(color: Colors.white),
      ),
    );
  }
}

class _DataCellText extends StatelessWidget {
  const _DataCellText(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(value),
    );
  }
}
