import 'package:flutter/material.dart';

/// Icono curado del catálogo (set finito, reutilizable).
class CatalogIconEntry {
  const CatalogIconEntry({
    required this.key,
    required this.icon,
    required this.emoji,
    required this.label,
  });

  final String key;
  final IconData icon;
  final String emoji;
  final String label;
}

/// Registro de iconos disponibles al crear lugares.
abstract final class CatalogIcons {
  static const defaultIconKey = 'pin';
  static const defaultCategoriaKey = 'label';

  static const _lugaresKeys = [
    'home',
    'box',
    'car',
    'moto',
    'van',
    'garage',
    'store',
    'work',
    'kitchen',
    'bed',
    'shelf',
    'tools',
    'pin',
    'label',
    'other',
  ];

  static const all = [
    CatalogIconEntry(key: 'home', icon: Icons.home_rounded, emoji: '🏠', label: 'Casa'),
    CatalogIconEntry(key: 'box', icon: Icons.inventory_2_rounded, emoji: '📦', label: 'Caja'),
    CatalogIconEntry(key: 'car', icon: Icons.directions_car_rounded, emoji: '🚗', label: 'Coche'),
    CatalogIconEntry(key: 'moto', icon: Icons.two_wheeler_rounded, emoji: '🏍️', label: 'Moto'),
    CatalogIconEntry(key: 'van', icon: Icons.local_shipping_rounded, emoji: '🚐', label: 'Furgoneta'),
    CatalogIconEntry(key: 'garage', icon: Icons.garage_rounded, emoji: '🅿️', label: 'Garaje'),
    CatalogIconEntry(key: 'store', icon: Icons.storefront_rounded, emoji: '🏪', label: 'Tienda'),
    CatalogIconEntry(key: 'work', icon: Icons.work_rounded, emoji: '💼', label: 'Trabajo'),
    CatalogIconEntry(key: 'kitchen', icon: Icons.kitchen_rounded, emoji: '🍳', label: 'Cocina'),
    CatalogIconEntry(key: 'bed', icon: Icons.bed_rounded, emoji: '🛏️', label: 'Habitación'),
    CatalogIconEntry(key: 'shelf', icon: Icons.shelves, emoji: '🗄️', label: 'Estantería'),
    CatalogIconEntry(key: 'tools', icon: Icons.build_rounded, emoji: '🔧', label: 'Herramientas'),
    CatalogIconEntry(key: 'pin', icon: Icons.place_rounded, emoji: '📍', label: 'Lugar'),
    CatalogIconEntry(key: 'label', icon: Icons.label_rounded, emoji: '🏷️', label: 'Etiqueta'),
    CatalogIconEntry(key: 'other', icon: Icons.push_pin_rounded, emoji: '📌', label: 'Otros'),
    // Iconos legacy (recuerdos de ejemplo, no se muestran al crear lugares).
    CatalogIconEntry(key: 'flight', icon: Icons.flight_rounded, emoji: '✈️', label: 'Avión'),
    CatalogIconEntry(key: 'key', icon: Icons.key_rounded, emoji: '🔑', label: 'Llaves'),
    CatalogIconEntry(key: 'document', icon: Icons.description_rounded, emoji: '📄', label: 'Documento'),
    CatalogIconEntry(key: 'camera', icon: Icons.photo_camera_rounded, emoji: '📷', label: 'Cámara'),
    CatalogIconEntry(key: 'backpack', icon: Icons.backpack_rounded, emoji: '🎒', label: 'Mochila'),
    CatalogIconEntry(key: 'luggage', icon: Icons.luggage_rounded, emoji: '🧳', label: 'Maleta'),
    CatalogIconEntry(key: 'electronics', icon: Icons.devices_rounded, emoji: '💻', label: 'Electrónica'),
  ];

  static final lugares = [
    for (final key in _lugaresKeys) byKey(key),
  ];

  static CatalogIconEntry get defaultIcon => byKey(defaultIconKey);

  static CatalogIconEntry get defaultCategoria => byKey(defaultCategoriaKey);

  static CatalogIconEntry byKey(String key) {
    for (final entry in all) {
      if (entry.key == key) return entry;
    }
    return all.first;
  }

  static IconData iconFor(String key) => byKey(key).icon;

  static String emojiFor(String key) => byKey(key).emoji;
}

/// Claves de color de marca para lugares.
abstract final class CatalogColorKeys {
  static const auto = 'auto';
  static const green = 'green';
  static const blue = 'blue';
  static const terracotta = 'terracotta';
  static const mustard = 'mustard';
  static const petrol = 'petrol';
  static const purple = 'purple';
  static const coral = 'coral';
  static const orange = 'orange';
  static const teal = 'teal';
  static const indigo = 'indigo';
  static const sage = 'sage';

  static const selectable = [
    green,
    blue,
    terracotta,
    mustard,
    petrol,
    purple,
    coral,
    orange,
    teal,
    indigo,
    sage,
  ];
}
