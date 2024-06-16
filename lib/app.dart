import 'package:flutter/material.dart';
import 'package:attendance_system/view/cameraview.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            backgroundColor: MaterialStatePropertyAll(
              Color.fromARGB(155, 104, 58, 183),
            ),
            textStyle: MaterialStatePropertyAll(
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
      initialRoute: '/camera',
      routes: {
        '/camera': (context) => const CameraView(),
      },
    );
  }
}
