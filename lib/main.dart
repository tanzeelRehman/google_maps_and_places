import 'package:flutter/material.dart';
import 'package:google_maps_and_places/map_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      home: MapScreen(),
    ),
  );
}
