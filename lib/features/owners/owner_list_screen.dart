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

import '../../shared/widgets/page_width.dart';
import 'owner.dart';
import 'owner_detail_screen.dart';
import 'owner_form_screen.dart';
import 'owner_service.dart';

class OwnerListScreen extends StatefulWidget {
  const OwnerListScreen({super.key});

  @override
  State<OwnerListScreen> createState() => _OwnerListScreenState();
}

class _OwnerListScreenState extends State<OwnerListScreen> {
  final OwnerService _ownerService = OwnerService();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;
  String _activeQuery = '';
  List<Owner> _owners = const [];

  @override
  void initState() {
    super.initState();
    _loadOwners();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadOwners({String? lastName}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _activeQuery = lastName?.trim() ?? '';
    });

    try {
      final owners = await _ownerService.listOwners(
        lastName: _activeQuery.isEmpty ? null : _activeQuery,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _owners = owners;
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
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => const OwnerFormScreen()),
    );
    if (changed == true) {
      await _loadOwners(lastName: _activeQuery);
    }
  }

  Future<void> _openOwnerDetail(Owner owner) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => OwnerDetailScreen(ownerId: owner.id!),
      ),
    );
    if (changed == true) {
      await _loadOwners(lastName: _activeQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Owners')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openOwnerForm,
        icon: const Icon(Icons.add),
        label: const Text('Add Owner'),
      ),
      body: AppPageWidth(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final stacked = constraints.maxWidth < 520;
                  final field = TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      labelText: 'Last name',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) =>
                        _loadOwners(lastName: _searchController.text.trim()),
                  );
                  final button = FilledButton(
                    onPressed: () =>
                        _loadOwners(lastName: _searchController.text.trim()),
                    child: const Text('Find'),
                  );

                  if (stacked) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [field, const SizedBox(height: 12), button],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: field),
                      const SizedBox(width: 12),
                      button,
                    ],
                  );
                },
              ),
            ),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
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
                onPressed: () => _loadOwners(lastName: _activeQuery),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_owners.isEmpty) {
      final message = _activeQuery.isEmpty
          ? 'No owners found.'
          : 'No owners with last name starting with "$_activeQuery".';
      return Center(child: Text(message));
    }

    return RefreshIndicator(
      onRefresh: () => _loadOwners(lastName: _activeQuery),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: _owners.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final owner = _owners[index];
          final petsLabel = owner.pets.isEmpty
              ? 'No pets'
              : owner.pets.map((pet) => pet.name).join(', ');

          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(owner.fullName),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '${owner.address}\n${owner.city}\nTelephone: ${owner.telephone}\nPets: $petsLabel',
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openOwnerDetail(owner),
            ),
          );
        },
      ),
    );
  }
}
