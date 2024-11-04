import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'login_page.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('MyBox'); // Open your Hive box
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Database Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: LoginPage(),
    );
  }
}


