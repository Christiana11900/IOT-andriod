import 'package:breathcare/ui/login.dart';
import 'package:breathcare/ui/util/route_constant.dart';
import 'package:flutter/material.dart';

import '../dashboard.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case login:
      return MaterialPageRoute(
        builder: (context) => const Loginscreen(),
      );
    case dashboard:
      return MaterialPageRoute(
        builder: (context) => const DashboardScreen(),
      );
    default:
      return MaterialPageRoute(
        // Make a screen for undefine
        builder: (context) => const Loginscreen(),
      );
  }
}
