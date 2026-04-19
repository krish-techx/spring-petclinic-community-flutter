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

import '../../shared/config/api_config.dart';
import '../../shared/widgets/page_width.dart';
import '../owners/owner_list_screen.dart';
import '../pettypes/pet_type_list_screen.dart';
import '../specialties/specialty_list_screen.dart';
import '../vets/vet_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = <_HomeEntry>[
      _HomeEntry(
        title: 'Owners',
        subtitle: 'Search owners, open details, add pets and visits.',
        icon: Icons.people_alt_outlined,
        destinationBuilder: (_) => const OwnerListScreen(),
      ),
      _HomeEntry(
        title: 'Veterinarians',
        subtitle: 'List, create, edit and delete vets.',
        icon: Icons.medical_services_outlined,
        destinationBuilder: (_) => const VetListScreen(),
      ),
      _HomeEntry(
        title: 'Pet Types',
        subtitle: 'Manage the catalog of pet types.',
        icon: Icons.pets_outlined,
        destinationBuilder: (_) => const PetTypeListScreen(),
      ),
      _HomeEntry(
        title: 'Specialties',
        subtitle: 'Manage veterinarian specialties.',
        icon: Icons.list_alt_outlined,
        destinationBuilder: (_) => const SpecialtyListScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Spring Petclinic')),
      body: AppPageWidth(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Frontend for Spring Petclinic',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This app targets the same REST API used by the Angular frontend.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    SelectableText(
                      'API: ${ApiConfig.baseUrl}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (final entry in entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(child: Icon(entry.icon)),
                    title: Text(entry.title),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(entry.subtitle),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: entry.destinationBuilder,
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HomeEntry {
  const _HomeEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.destinationBuilder,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final WidgetBuilder destinationBuilder;
}
