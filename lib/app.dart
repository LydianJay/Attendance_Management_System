import 'package:flutter/material.dart';

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
      title: 'Bgry Taft Information System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // initialRoute: fRoute,
      // routes: {
      //   '/login': (context) => const LoginView(),
      //   '/dashboard': (context) => const DashBoardView(),
      //   '/locked': (context) => const LockedView(),
      // },
    );
  }
}
