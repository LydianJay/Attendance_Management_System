import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';
import 'package:attendance_system/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  sqfliteFfiInit();

  databaseFactory = databaseFactoryFfi;
  WindowOptions windowOptions = const WindowOptions(
    // size: Size(1000, 800),
    // maximumSize: Size(1000, 800),
    center: false,
    fullScreen: true,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    windowButtonVisibility: false,
    title: "Attendance System",
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}
