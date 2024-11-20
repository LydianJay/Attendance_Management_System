import 'package:attendance_system/db/database.dart';
import 'package:attendance_system/view/settings.dart';
// import 'package:attendance_system/view/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:attendance_system/view/cameraview.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // var currentDate = DateTime.now();

    // String fRoute = '/login';

    // if (currentDate.year > 2024 ||
    //     (currentDate.day >= 23 && currentDate.month >= 3)) {
    //   fRoute = '/locked';
    // }

    return MaterialApp(
      restorationScopeId: 'ID',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.deepPurple),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Color.fromARGB(155, 104, 58, 183),
            ),
            textStyle: WidgetStatePropertyAll(
              TextStyle(
                color: Colors.white,
                fontFamily: 'Helvetica',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      initialRoute: '/settings',
      routes: {
        '/camera': (context) => const CameraView(),
        '/settings': (context) => const SettingsView(),
        // '/dashboard': (context) => const DashBoard(),
      },
    );
  }
}
