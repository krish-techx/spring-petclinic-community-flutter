import 'package:flutter/material.dart';

import '../../shared/forms/app_validators.dart';
import 'pet_type.dart';
import 'pet_type_service.dart';

class PetTypeFormScreen extends StatefulWidget {
  const PetTypeFormScreen({super.key, this.petType});

  final PetType? petType;

  @override
  State<PetTypeFormScreen> createState() => _PetTypeFormScreenState();
}

class _PetTypeFormScreenState extends State<PetTypeFormScreen> {
  final PetTypeService _petTypeService = PetTypeService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  bool _isSaving = false;
  String? _errorMessage;

  bool get _isEditing => widget.petType != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.petType?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final petType = PetType(
      id: widget.petType?.id,
      name: _nameController.text.trim(),
    );

    try {
      if (_isEditing) {
        await _petTypeService.updatePetType(petType);
      } else {
        await _petTypeService.createPetType(petType);
      }

      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
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
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Pet Type' : 'New Pet Type'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_errorMessage != null) ...[
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(_errorMessage!),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: AppValidators.plainText(
                    'Name',
                    minLength: 1,
                    maxLength: 80,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isSaving ? null : _save,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(_isEditing ? 'Update' : 'Save'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
