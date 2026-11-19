import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Contenido de barra de estado oscuro sobre fondos claros.
  // El splash lo sobrescribe con `AnnotatedRegion` a contenido claro.
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  runApp(const ShareWayApp());
}
