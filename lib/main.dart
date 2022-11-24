import 'package:flutter/material.dart';
import 'package:sppl_assignment/screens/authorization/user_details.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SPPL Assignment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserDetailsForm(),
    );
  }
}
