import 'package:flutter/material.dart';
import 'userService.dart';
import 'homePage.dart';
import 'adminPage.dart';
import 'signUpPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    bool isAdmin = await UserService.loginAdmin(username, password);

    if (isAdmin) {
      usernameController.clear();
      passwordController.clear();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboardPage()),
      );
    } else {
      final user = await UserService.loginUser(username, password);

      if (user != null) {
        usernameController.clear();
        passwordController.clear();

     Navigator.of(context).push(
     MaterialPageRoute(builder: (context) => HomePage(username:username)),
      );

      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Invalid username or password'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void navigateToSignUpPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(onPressed: login, child: Text('Login')),
            SizedBox(height: 20.0),
            ElevatedButton(onPressed: navigateToSignUpPage, child: Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}
