import 'package:breathcare/ui/login.dart';
import 'package:breathcare/ui/util/route_constant.dart';
import 'package:breathcare/ui/util/router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      title: 'Real Estate app',
      //theme: AppTheme.lightTheme(context),
      themeMode: ThemeMode.light,
      onGenerateRoute: generateRoute,
      initialRoute: login,
    );
  }
}