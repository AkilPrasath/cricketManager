import 'package:cricket_team_creator/UI/captain_dashboard.dart';
import 'package:cricket_team_creator/UI/login_screen.dart';
import 'package:cricket_team_creator/services/get_it_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: LoginScreen.id,
    routes: {
      LoginScreen.id: (context) => LoginScreen(),
      CaptainDashboard.id: (context) => CaptainDashboard()
    },
  ));
}
