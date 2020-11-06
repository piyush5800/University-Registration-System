import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'ViewStudentDetails.dart';

class SubmittedApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    DocumentSnapshot userData = arguments['data'];
    return Scaffold(
      appBar: AppBar(
        title: Text("View Submitted Application"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Column(
              children: [
                Text(
                  "We have received the following details from you. Please contact the admin for any discrepancy.",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                StudentDetails(
                  userData: userData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
