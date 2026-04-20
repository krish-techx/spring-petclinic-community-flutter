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

import '../../shared/widgets/confirmation_dialog.dart';
import '../../shared/widgets/classic_scaffold.dart';
import 'specialty.dart';
import 'specialty_form_screen.dart';
import 'specialty_service.dart';

class SpecialtyListScreen extends StatefulWidget {
  const SpecialtyListScreen({super.key});

  @override
  State<SpecialtyListScreen> createState() => _SpecialtyListScreenState();
}

class _SpecialtyListScreenState extends State<SpecialtyListScreen> {
  final SpecialtyService _specialtyService = SpecialtyService();

  bool _isLoading = true;
  String? _errorMessage;
  List<Specialty> _specialties = const [];

  @override
  void initState() {
    super.initState();
    _loadSpecialties();
  }

  Future<void> _loadSpecialties() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final specialties = await _specialtyService.listSpecialties();
      if (!mounted) {
        return;
      }
      setState(() {
        _specialties = specialties;
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

  Future<void> _openForm({Specialty? specialty}) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => SpecialtyFormScreen(specialty: specialty),
      ),
    );
    if (changed == true) {
      await _loadSpecialties();
    }
  }

  Future<void> _deleteSpecialty(Specialty specialty) async {
    if (specialty.id == null) {
      return;
    }

    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete specialty?',
      message: 'Delete ${specialty.name}? This action cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (!confirmed) {
      return;
    }

    try {
      await _specialtyService.deleteSpecialty(specialty.id!);
      await _loadSpecialties();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${specialty.name} deleted.')));
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
    return ClassicScaffold(
      section: ClassicSection.specialties,
      title: 'Specialties',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: _buildBody(),
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
                onPressed: _loadSpecialties,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_specialties.isEmpty) {
      return const Center(child: Text('No specialties found.'));
    }

    return RefreshIndicator(
      onRefresh: _loadSpecialties,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: _specialties.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final specialty = _specialties[index];
          return Card(
            child: ListTile(
              title: Text(specialty.name),
              trailing: Wrap(
                spacing: 4,
                children: [
                  IconButton(
                    onPressed: () => _openForm(specialty: specialty),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    onPressed: () => _deleteSpecialty(specialty),
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
