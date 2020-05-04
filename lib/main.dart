import 'package:flutter/material.dart';
import 'package:up_depense/screens/home/home.dart';
import 'package:up_depense/screens/home/login.dart';
import 'package:up_depense/screens/splach.dart';

main() => runApp(
      AppDepense(),
    );

class AppDepense extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        UpdepenseHome.routeName: (context) => UpdepenseHome(),
        Login.routeName: (context) => Login(),
      },
      theme: ThemeData(
        primaryColor: Color(0XFF1686D9),
        primarySwatch: Colors.lightBlue,
      ),
      home: Splach(),
    );
  }
}
