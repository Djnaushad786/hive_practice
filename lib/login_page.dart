import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'homepage.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void loginUser(BuildContext context) {
    final box = Hive.box("MyBox");
    final username = usernameController.text;
    final password = passwordController.text;

    // Check if the username exists and the password matches
    if (box.containsKey(username) && box.get(username) == password) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successful")));
      // Navigate to Homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
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
            ElevatedButton(
              onPressed: () => loginUser(context),
              child: Text("Login"),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
              },
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
