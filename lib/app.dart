import 'package:attendance_system/db/database.dart';
import 'package:attendance_system/view/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:attendance_system/view/cameraview.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void getDB() async {
    await DataBase.initDatabase();

    // final res = await DataBase.db!.query('attendance');

    // debugPrint('length: ${res.length}');
    // for (var v in res) {
    //   debugPrint(
    //       'ID ${v['rID'].toString()} - TimeIn: ${v['timeIn'].toString()} - Date: ${v['date'].toString()}');
    // }

    // var value = {
    //   'fname': 'Sander',
    //   'lname': 'Cahulugan',
    //   'mname': 'L',
    // };
    // DataBase.db!.insert('employee', value);
    // value = {
    //   'fname': 'Arjelyn',
    //   'lname': 'Dela Torre',
    //   'mname': 'D',
    // };
    // DataBase.db!.insert('employee', value);
    // value = {
    //   'fname': 'Arnold',
    //   'lname': 'Dela Torre',
    //   'mname': 'V',
    // };
    // DataBase.db!.insert('employee', value);
  }

  @override
  void initState() {
    super.initState();
    getDB();
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
      initialRoute: '/dashboard',
      routes: {
        '/camera': (context) => const CameraView(),
        '/dashboard': (context) => const DashBoard(),
      },
    );
  }
}
