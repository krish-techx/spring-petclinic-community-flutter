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
import '../../shared/navigation/app_routes.dart';
import '../../shared/theme/classic_theme.dart';
import '../../shared/widgets/classic_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = <_HomeEntry>[
      _HomeEntry(
        title: 'Owners',
        icon: Icons.people_alt_outlined,
        routeName: AppRoutes.owners,
      ),
      _HomeEntry(
        title: 'Veterinarians',
        icon: Icons.medical_services_outlined,
        routeName: AppRoutes.veterinarians,
      ),
      _HomeEntry(
        title: 'Pet Types',
        icon: Icons.pets_outlined,
        routeName: AppRoutes.petTypes,
      ),
      _HomeEntry(
        title: 'Specialties',
        icon: Icons.list_alt_outlined,
        routeName: AppRoutes.specialties,
      ),
    ];

    return ClassicScaffold(
      section: ClassicSection.home,
      title: 'Spring Petclinic',
      showPageTitle: false,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
        children: [
          Text(
            'Welcome to Petclinic',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Text('Welcome', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: ClassicPalette.border),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset('assets/images/pets.png', fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Jump directly to a section:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final entry in entries)
                OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(entry.routeName),
                  icon: Icon(entry.icon, size: 18),
                  label: Text(entry.title),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'This app targets the same REST API used by the Angular frontend.',
          ),
          const SizedBox(height: 10),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: ClassicPalette.border),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: SelectableText(
                'API: ${ApiConfig.baseUrl}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeEntry {
  const _HomeEntry({
    required this.title,
    required this.icon,
    required this.routeName,
  });

  final String title;
  final IconData icon;
  final String routeName;
}
