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

import '../../shared/forms/app_validators.dart';
import '../../shared/widgets/page_width.dart';
import 'specialty.dart';
import 'specialty_service.dart';

class SpecialtyFormScreen extends StatefulWidget {
  const SpecialtyFormScreen({super.key, this.specialty});

  final Specialty? specialty;

  @override
  State<SpecialtyFormScreen> createState() => _SpecialtyFormScreenState();
}

class _SpecialtyFormScreenState extends State<SpecialtyFormScreen> {
  final SpecialtyService _specialtyService = SpecialtyService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  bool _isSaving = false;
  String? _errorMessage;

  bool get _isEditing => widget.specialty != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.specialty?.name ?? '');
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

    final specialty = Specialty(
      id: widget.specialty?.id,
      name: _nameController.text.trim(),
    );

    try {
      if (_isEditing) {
        await _specialtyService.updateSpecialty(specialty);
      } else {
        await _specialtyService.createSpecialty(specialty);
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
        title: Text(_isEditing ? 'Edit Specialty' : 'New Specialty'),
      ),
      body: AppPageWidth(
        maxWidth: 720,
        child: ListView(
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
      ),
    );
  }
}
