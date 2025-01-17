import 'package:flutter/material.dart';
import 'package:habit_tracker/Screen/AddHabitScreen.dart';
import 'package:habit_tracker/Screen/HabitTrackerScreen.dart';

import 'package:habit_tracker/Screen/LoginScreen.dart';
import 'package:habit_tracker/Screen/RecoverPassword.dart';
import 'package:habit_tracker/Screen/RegisterScreen.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: RegisterScreen(),
        debugShowCheckedModeBanner: false,
    );
  }
}



