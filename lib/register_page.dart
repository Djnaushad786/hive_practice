import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void registerUser(BuildContext context) {
    final box = Hive.box("MyBox");
    final username = usernameController.text;
    final password = passwordController.text;

    if (box.containsKey(username)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Username already exists!")));
    } else {
      box.put(username, password);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User registered!")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Username",border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password",border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => registerUser(context), child: Text("Register")),
          ],
        ),
      ),
    );
  }
}
