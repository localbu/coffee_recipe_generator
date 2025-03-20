import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:schedule_generator/screen/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize hive
  await Hive.initFlutter(); 

  // open the box
  var box = await Hive.openBox('coffeeBox');


  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainScreen(),
    );
  }
}
