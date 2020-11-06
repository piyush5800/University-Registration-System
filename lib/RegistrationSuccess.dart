import 'package:flutter/material.dart';

class RegistrationSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    String password = arguments["password"];
    String role = arguments['role'];
    bool isStaff = role == 'staff' ? true : false;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text("New Enrolment"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "SUCCESS",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.done,
                    size: 100,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (!isStaff)
                    Text(
                      "Your registration was successful. We have received your details and will review if you are a good fit for our university.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  if (isStaff)
                    Text(
                      "The applicant details were added to the database successfully.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (!isStaff)
                    Text(
                      "You can check you application status using your registered email address and the password given below.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  if (isStaff)
                    Text(
                      "Please communicate the below password and the registered email address to the student.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Password:",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "$password",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  if (!isStaff)
                    Text(
                      "Press the button below to be redirected back to the login screen.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  if (isStaff)
                    Text(
                      "Press the button below to be redirected back to the Dashboard.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 300,
                    child: RaisedButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      onPressed: () {
                        if (!isStaff) {
                          Navigator.popUntil(
                              context, ModalRoute.withName('/login'));
                        } else {
                          Navigator.popUntil(
                              context, ModalRoute.withName('/dashboard'));
                        }
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
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
        ),
      ),
    );
  }
}
