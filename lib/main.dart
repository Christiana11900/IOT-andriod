import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:breathcare/ui/login.dart';
import 'package:breathcare/ui/util/app_string.dart';
import 'package:breathcare/ui/util/route_constant.dart';
import 'package:breathcare/ui/util/router.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    null, // make this an empty string in case it doesn't work
    [
      // notification channel for basic notification
      NotificationChannel(
        channelKey: AppStrings.BASIC_CHANNEL_KEY,
        channelName: AppStrings.BASIC_CHANNEL_NAME,
        channelDescription: AppStrings.BASIC_CHANNEL_DESCRIPTION,
        //defaultColor: const Color(0XFF0a0a0a),
        importance: NotificationImportance.High,
        defaultRingtoneType: DefaultRingtoneType.Notification,
      ),
    ],
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      title: 'BreatSafe',
      debugShowCheckedModeBanner: false,
      //theme: AppTheme.lightTheme(context),
      themeMode: ThemeMode.light,
      onGenerateRoute: generateRoute,
      initialRoute: login,
    );
  }
}