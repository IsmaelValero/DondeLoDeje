import 'package:flutter/material.dart';

import '../widgets/app_navigation.dart';
import 'lugares_screen.dart';
import 'mas_screen.dart';
import 'recuerdos_screen.dart';
import 'viajes_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  final _screens = const [
    RecuerdosScreen(),
    LugaresScreen(),
    ViajesScreen(),
    MasScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: AppBottomNav(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
      ),
      floatingActionButton: AppFab(
        onPressed: () {
          // Crear recuerdo — próxima fase
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
