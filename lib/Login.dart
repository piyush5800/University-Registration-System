import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'LoginData.dart';
import 'package:validators/validators.dart' as validator;
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LoginForm(),
              Container(
                width: 300,
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  onPressed: () {
                    Navigator.pushNamed(context, '/newEnrolment');
                  },
                  child: Text(
                    "New Student? Apply Here",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  LoginData _data = LoginData();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            width: 300,
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter the email";
                } else if (!validator.isEmail(value)) {
                  return "Please enter the correct email";
                }
                return null;
              },
              onSaved: (value) {
                this._data.email = value;
              },
              autocorrect: false,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Email",
                contentPadding: EdgeInsets.all(8.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: 300,
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter the password";
                }
                return null;
              },
              onSaved: (value) {
                this._data.password = value;
              },
              textAlign: TextAlign.center,
              obscureText: true,
              enableSuggestions: false,
              decoration: InputDecoration(
                hintText: "Password",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: 300,
            child: RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(18.0),
                ),
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                setState(() {
                  this.isLoading = true;
                });

                await Firebase.initializeApp();
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  try {
                    User user =
                        (await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: this._data.email,
                      password: this._data.password,
                    ))
                            .user;
                    if (user != null) {
                      QuerySnapshot deletedData = await FirebaseFirestore
                          .instance
                          .collection('deleted')
                          .where('email', isEqualTo: this._data.email)
                          .get();
                      if (deletedData.size > 0) {
                        setState(() {
                          this.isLoading = false;
                        });
                        final snackBar = SnackBar(
                            content: Text(
                                "This user was deleted. Please contact admin."));
                        Scaffold.of(context).showSnackBar(snackBar);
                      } else {
                        DocumentSnapshot userData = await FirebaseFirestore
                            .instance
                            .collection('admin')
                            .doc(user.uid)
                            .get();
                        if (userData.exists) {
                          setState(() {
                            this.isLoading = false;
                          });
                          print("Data found for ${userData['firstName']}.");
                          Navigator.pushNamed(context, '/dashboard',
                              arguments: {'data': userData, 'role': "admin"});
                        } else {
                          DocumentSnapshot userData = await FirebaseFirestore
                              .instance
                              .collection('DEO')
                              .doc(user.uid)
                              .get();
                          if (userData.exists) {
                            setState(() {
                              this.isLoading = false;
                            });
                            print("Data found for ${userData['firstName']}.");
                            Navigator.pushNamed(context, '/dashboard',
                                arguments: {'data': userData, "role": "DEO"});
                          } else {
                            DocumentSnapshot userData = await FirebaseFirestore
                                .instance
                                .collection('students')
                                .doc(user.uid)
                                .get();
                            if (userData.exists) {
                              setState(() {
                                this.isLoading = false;
                              });
                              print("Data found for ${userData['firstName']}.");
                              Navigator.pushNamed(context, '/dashboard',
                                  arguments: {
                                    'data': userData,
                                    "role": "student",
                                    "uid": user.uid,
                                  });
                            }
                          }
                        }
                      }
                    }
                  } catch (e) {
                    print(e);
                    switch (e.code) {
                      case "wrong-password":
                        {
                          setState(() {
                            this.isLoading = false;
                          });
                          final snackBar =
                              SnackBar(content: Text("Wrong Password"));
                          Scaffold.of(context).showSnackBar(snackBar);

                          break;
                        }
                      case "user-not-found":
                        {
                          setState(() {
                            this.isLoading = false;
                          });
                          final snackBar = SnackBar(
                              content: Text(
                                  "User with the entered email doesn't exist."));
                          Scaffold.of(context).showSnackBar(snackBar);

                          break;
                        }
                      case "too-many-requests":
                        {
                          setState(() {
                            this.isLoading = false;
                          });
                          final snackBar = SnackBar(
                              content: Text(
                                  "Too many failed attempts. Please contact admin."));
                          Scaffold.of(context).showSnackBar(snackBar);

                          break;
                        }
                      case "network-request-failed":
                        {
                          setState(() {
                            this.isLoading = false;
                          });
                          final snackBar =
                              SnackBar(content: Text("No internet connection"));
                          Scaffold.of(context).showSnackBar(snackBar);

                          break;
                        }
                    }
                  }
                }
              },
              child: Text(
                "LOGIN",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          if (this.isLoading) CircularProgressIndicator()
        ],
      ),
    );
  }
}
