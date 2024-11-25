import 'package:flutter/material.dart';
import 'package:latres/pages/registerpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latres/pages/homepage.dart';

class loginpage extends StatefulWidget {
  loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  bool visible = true;
  late SharedPreferences logindata;
  late bool newuser;
  String username_controler = '';
  String password_controler = '';
  @override
  void initState() {
    super.initState();
    check_if_already_login();
  }

  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    if (newuser == false) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => homepage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin:
                  EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                onChanged: (value) {
                  username_controler = value;
                },
                decoration: InputDecoration(
                  label: Container(
                    width: 100,
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        Text('username'),
                      ],
                    ),
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(8.0),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                ),
              ),
            ),
            Container(
              margin:
                  EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                onChanged: (value) {
                  password_controler = value;
                },
                obscureText: visible,
                decoration: InputDecoration(
                  suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          visible = !visible;
                        });
                      },
                      icon: visible
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility)),
                  filled: true,
                  label: Container(
                    width: 100,
                    child: Row(
                      children: [
                        Icon(Icons.lock),
                        Text('Password'),
                      ],
                    ),
                  ),
                  contentPadding: EdgeInsets.all(8.0),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        child: Text('Login'))),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => registerpage()));
                        },
                        child: Text('Register'))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void login() async {
    logindata = await SharedPreferences.getInstance();
    String? username = logindata.getString('username');
    String? password = logindata.getString('password');

    if (username_controler == username && password_controler == password) {
      logindata.setBool('login', false);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => homepage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username salah atau password salah')),
      );
    }
  }
}
