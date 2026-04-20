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

import 'features/home/home_screen.dart';
import 'features/owners/owner_list_screen.dart';
import 'features/pettypes/pet_type_list_screen.dart';
import 'features/specialties/specialty_list_screen.dart';
import 'features/vets/vet_list_screen.dart';
import 'shared/navigation/app_routes.dart';
import 'shared/theme/classic_theme.dart';

void main() {
  runApp(const PetClinicApp());
}

class PetClinicApp extends StatelessWidget {
  const PetClinicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spring Petclinic',
      debugShowCheckedModeBanner: false,
      theme: ClassicPalette.buildTheme(),
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.owners: (_) => const OwnerListScreen(),
        AppRoutes.veterinarians: (_) => const VetListScreen(),
        AppRoutes.petTypes: (_) => const PetTypeListScreen(),
        AppRoutes.specialties: (_) => const SpecialtyListScreen(),
      },
    );
  }
}
