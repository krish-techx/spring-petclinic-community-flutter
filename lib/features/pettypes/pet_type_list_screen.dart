import 'package:flutter/material.dart';

import '../../shared/widgets/confirmation_dialog.dart';
import '../../shared/widgets/page_width.dart';
import 'pet_type.dart';
import 'pet_type_form_screen.dart';
import 'pet_type_service.dart';

class PetTypeListScreen extends StatefulWidget {
  const PetTypeListScreen({super.key});

  @override
  State<PetTypeListScreen> createState() => _PetTypeListScreenState();
}

class _PetTypeListScreenState extends State<PetTypeListScreen> {
  final PetTypeService _petTypeService = PetTypeService();

  bool _isLoading = true;
  String? _errorMessage;
  List<PetType> _petTypes = const [];

  @override
  void initState() {
    super.initState();
    _loadPetTypes();
  }

  Future<void> _loadPetTypes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final petTypes = await _petTypeService.listPetTypes();
      if (!mounted) {
        return;
      }
      setState(() {
        _petTypes = petTypes;
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

  Future<void> _openForm({PetType? petType}) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => PetTypeFormScreen(petType: petType),
      ),
    );
    if (changed == true) {
      await _loadPetTypes();
    }
  }

  Future<void> _deletePetType(PetType petType) async {
    if (petType.id == null) {
      return;
    }

    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete pet type?',
      message: 'Delete ${petType.name}? This action cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (!confirmed) {
      return;
    }

    try {
      await _petTypeService.deletePetType(petType.id!);
      await _loadPetTypes();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${petType.name} deleted.')));
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
    return Scaffold(
      appBar: AppBar(title: const Text('Pet Types')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: AppPageWidth(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _loadPetTypes,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_petTypes.isEmpty) {
      return const Center(child: Text('No pet types found.'));
    }

    return RefreshIndicator(
      onRefresh: _loadPetTypes,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: _petTypes.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final petType = _petTypes[index];
          return Card(
            child: ListTile(
              title: Text(petType.name),
              trailing: Wrap(
                spacing: 4,
                children: [
                  IconButton(
                    onPressed: () => _openForm(petType: petType),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    onPressed: () => _deletePetType(petType),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
