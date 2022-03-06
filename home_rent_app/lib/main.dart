import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_rent_app/screens/authentication/login_screen.dart';

import 'package:home_rent_app/utils/size_config.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SizeConfig().init(constraints);
        return MaterialApp(
          title: 'Home Rent App',
          theme: ThemeData(
            
            primarySwatch: Colors.blue,
          ),
          home: LoginScreen(),
        );
      }
    );
  }
}

