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

import '../navigation/app_routes.dart';
import '../theme/classic_theme.dart';
import 'page_width.dart';

enum ClassicSection { home, owners, veterinarians, petTypes, specialties }

class ClassicScaffold extends StatelessWidget {
  const ClassicScaffold({
    super.key,
    required this.section,
    required this.body,
    required this.title,
    this.floatingActionButton,
    this.showPageTitle = true,
    this.showFooter = true,
  });

  final ClassicSection section;
  final Widget body;
  final String title;
  final Widget? floatingActionButton;
  final bool showPageTitle;
  final bool showFooter;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      appBar: isWide ? null : const _MobileTopBar(),
      drawer: isWide ? null : _ClassicDrawer(section: section),
      floatingActionButton: floatingActionButton,
      body: Column(
        children: [
          if (isWide) _WideTopBar(section: section),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: AppPageWidth(
                maxWidth: 1180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showPageTitle) ...[
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20),
                    ],
                    Expanded(child: body),
                  ],
                ),
              ),
            ),
          ),
          if (isWide && showFooter) const _ClassicFooter(),
        ],
      ),
    );
  }
}

class _MobileTopBar extends StatelessWidget implements PreferredSizeWidget {
  const _MobileTopBar();

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 66,
      titleSpacing: 16,
      title: Image.asset(
        'assets/images/spring-logo-dataflow-mobile.png',
        height: 34,
        fit: BoxFit.contain,
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(4),
        child: SizedBox(
          height: 4,
          child: DecoratedBox(
            decoration: BoxDecoration(color: ClassicPalette.accent),
          ),
        ),
      ),
    );
  }
}

class _WideTopBar extends StatelessWidget {
  const _WideTopBar({required this.section});

  final ClassicSection section;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ClassicPalette.navbar,
        border: Border(top: BorderSide(color: ClassicPalette.accent, width: 4)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          height: 84,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Image.asset(
                  'assets/images/spring-logo-dataflow.png',
                  height: 46,
                  fit: BoxFit.contain,
                ),
              ),
              for (final item in _navItems)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextButton.icon(
                    onPressed: item.section == section
                        ? null
                        : () => _navigateTo(context, item.route),
                    icon: Icon(
                      item.icon,
                      size: 16,
                      color: item.section == section
                          ? ClassicPalette.accent
                          : Colors.white,
                    ),
                    label: Text(
                      item.label.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: item.section == section
                            ? ClassicPalette.accent
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClassicDrawer extends StatelessWidget {
  const _ClassicDrawer({required this.section});

  final ClassicSection section;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: ClassicPalette.navbar,
              border: Border(
                top: BorderSide(color: ClassicPalette.accent, width: 4),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/images/spring-logo-dataflow-mobile.png',
                height: 38,
                fit: BoxFit.contain,
              ),
            ),
          ),
          for (final item in _navItems)
            ListTile(
              leading: Icon(
                item.icon,
                color: item.section == section
                    ? ClassicPalette.accent
                    : ClassicPalette.text,
              ),
              title: Text(item.label),
              selected: item.section == section,
              onTap: item.section == section
                  ? () => Navigator.of(context).pop()
                  : () {
                      Navigator.of(context).pop();
                      _navigateTo(context, item.route);
                    },
            ),
        ],
      ),
    );
  }
}

class _ClassicFooter extends StatelessWidget {
  const _ClassicFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: AppPageWidth(
        maxWidth: 1180,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/icon_flutter.png', height: 70),
            const SizedBox(width: 20),
            Image.asset('assets/images/spring-pivotal-logo.png', height: 42),
          ],
        ),
      ),
    );
  }
}

class _ClassicNavItem {
  const _ClassicNavItem({
    required this.section,
    required this.label,
    required this.route,
    required this.icon,
  });

  final ClassicSection section;
  final String label;
  final String route;
  final IconData icon;
}

const _navItems = <_ClassicNavItem>[
  _ClassicNavItem(
    section: ClassicSection.home,
    label: 'Home',
    route: AppRoutes.home,
    icon: Icons.home,
  ),
  _ClassicNavItem(
    section: ClassicSection.owners,
    label: 'Owners',
    route: AppRoutes.owners,
    icon: Icons.person,
  ),
  _ClassicNavItem(
    section: ClassicSection.veterinarians,
    label: 'Veterinarians',
    route: AppRoutes.veterinarians,
    icon: Icons.school,
  ),
  _ClassicNavItem(
    section: ClassicSection.petTypes,
    label: 'Pet Types',
    route: AppRoutes.petTypes,
    icon: Icons.pets,
  ),
  _ClassicNavItem(
    section: ClassicSection.specialties,
    label: 'Specialties',
    route: AppRoutes.specialties,
    icon: Icons.list,
  ),
];

void _navigateTo(BuildContext context, String routeName) {
  final navigator = Navigator.of(context);
  final currentRoute = ModalRoute.of(context)?.settings.name;
  if (currentRoute == routeName) {
    return;
  }
  navigator.pushNamedAndRemoveUntil(routeName, (route) => false);
}
