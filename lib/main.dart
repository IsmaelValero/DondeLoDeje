import 'package:flutter/material.dart';

import 'app.dart';
import 'data/persistencia.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Persistencia.init();
  } catch (_) {
    // Si el almacenamiento falla, la app arranca igualmente sin datos previos.
  }

  runApp(const DondeLoDejeApp());
}
