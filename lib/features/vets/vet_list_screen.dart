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
import 'vet.dart';
import 'vet_form_screen.dart';
import 'vet_service.dart';

class VetListScreen extends StatefulWidget {
  const VetListScreen({super.key, this.vetService});

  final VetService? vetService;

  @override
  State<VetListScreen> createState() => _VetListScreenState();
}

class _VetListScreenState extends State<VetListScreen> {
  late final VetService _vetService = widget.vetService ?? VetService();

  bool _isLoading = true;
  String? _errorMessage;
  List<Vet> _vets = const [];

  @override
  void initState() {
    super.initState();
    _loadVets();
  }

  Future<void> _loadVets() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final vets = await _vetService.listVets();
      if (!mounted) {
        return;
      }
      setState(() {
        _vets = vets;
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

  Future<void> _openForm({int? vetId}) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => VetFormScreen(vetId: vetId)),
    );
    if (changed == true) {
      await _loadVets();
    }
  }

  Future<void> _deleteVet(Vet vet) async {
    if (vet.id == null) {
      return;
    }

    final confirmed = await showConfirmationDialog(
      context,
      title: 'Delete veterinarian?',
      message: 'Delete ${vet.fullName}? This action cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (!confirmed) {
      return;
    }

    try {
      await _vetService.deleteVet(vet.id!);
      await _loadVets();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${vet.fullName} deleted.')));
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
      section: ClassicSection.veterinarians,
      title: 'Veterinarians',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add Vet'),
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
              FilledButton(onPressed: _loadVets, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (_vets.isEmpty) {
      return const Center(child: Text('No veterinarians found.'));
    }

    return RefreshIndicator(
      onRefresh: _loadVets,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: _vets.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final vet = _vets[index];
          final specialties = vet.specialties.isEmpty
              ? 'No specialties'
              : vet.specialties.map((specialty) => specialty.name).join(', ');

          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(vet.fullName),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('Specialties: $specialties'),
              ),
              trailing: Wrap(
                spacing: 4,
                children: [
                  IconButton(
                    onPressed: () => _openForm(vetId: vet.id),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    onPressed: () => _deleteVet(vet),
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
