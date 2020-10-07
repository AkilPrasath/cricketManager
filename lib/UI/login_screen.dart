import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:cricket_team_creator/UI/captain_dashboard.dart';
import 'package:cricket_team_creator/services/database_functions.dart';
import 'package:cricket_team_creator/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static final String id = "Login Screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = "";
  String _password = "";
  Stream<User> authStateListener = FirebaseAuth.instance.authStateChanges();
  FocusNode _focusNodeEmail, _focusNodePassword;
  RegExp emailRegex = RegExp(
      r'''(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])''');
  // RegExp emailRegex =
  // RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Z0-9.-]+\.[A-Z]{2,}$");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    authStateListener.listen((event) {
      print(event);
    });
    _focusNodeEmail = FocusNode();
    _focusNodePassword = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<FirebaseApp>(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.none) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Cricket Manager",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            CustomTextField(
                              hintText: "email (use 'captain@gmail.com')",
                              isPassword: false,
                              onChanged: (val) {
                                _email = val;
                              },
                              onSubmitted: (val) {
                                _focusNodePassword.requestFocus();
                              },
                              focusNode: _focusNodeEmail,
                              textInputAction: TextInputAction.next,
                              validator: (email) {
                                if (!emailRegex.hasMatch(email)) {
                                  return "Invalid Email Format";
                                }
                                return null;
                              },
                            ),
                            CustomTextField(
                              hintText: "Password (use 'captain@gmail.com')",
                              isPassword: true,
                              onChanged: (val) {
                                _password = val;
                              },
                              focusNode: _focusNodePassword,
                              textInputAction: TextInputAction.go,
                              onSubmitted: (val) {
                                _focusNodePassword.unfocus();
                              },
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Builder(builder: (context) {
                                  return RaisedButton(
                                    // color: Color(0xff003000),
                                    color: Color(0xff1A5302),
                                    onPressed: () async {
                                      if (ConnectivityResult.none ==
                                          await Connectivity()
                                              .checkConnectivity()) {
                                        Scaffold.of(context).showSnackBar(SnackBar(
                                            content: Text(
                                                "Check your internet connection")));
                                        return;
                                      }
                                      if (!emailRegex.hasMatch(_email.trim())) {
                                        print(_email.trim());
                                        Scaffold.of(context).showSnackBar(SnackBar(
                                            content: Text(
                                                "Please check your Email format!")));
                                        return;
                                      }
                                      if (_password.isEmpty) {
                                        Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "Please enter password")));
                                        return;
                                      }
                                      //TODO check network connectivity here
                                      SignInResult authResult =
                                          await DatabaseService()
                                              .login(_email, _password);
                                      if (authResult ==
                                          SignInResult.wrongPassword) {
                                        Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text("Wrong Password")));
                                        return;
                                      } else if (authResult ==
                                          SignInResult.userNotFound) {
                                        Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text("No User Found!")));
                                        return;
                                      } else {
                                        if (authResult ==
                                            SignInResult.captain) {
                                          //TODO navigate to captain
                                          // Navigator.pop(context);

                                          await DatabaseService()
                                              .getPlayerDetails();
                                          Navigator.popAndPushNamed(
                                              context, CaptainDashboard.id);
                                        } else if (authResult ==
                                            SignInResult.player) {
                                          //TODO navigate to player
                                          print("Player");
                                        }
                                      }
                                    },
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
