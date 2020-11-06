import 'package:flutter/material.dart';

class ApplicationStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        title: Text("Application Status"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: ApplicationStatusBody(
              status: arguments['status'],
              allotedBranch: arguments['allotedBranch'],
              branchName: arguments['branchName'],
            ),
          ),
        ),
      ),
    );
  }
}

class ApplicationStatusBody extends StatelessWidget {
  final String status;
  final String allotedBranch;
  final String branchName;

  ApplicationStatusBody({this.status, this.allotedBranch, this.branchName});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 50,
        ),
        Text(
          "Your application status is",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        if (this.status == 'In Review')
          Text(
            this.status,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50,
              color: Colors.deepOrange,
            ),
          ),
        if (this.status == 'Confirmed')
          Text(
            this.status,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50,
              color: Colors.green,
            ),
          ),
        if (this.status == "Confirmed")
          SizedBox(
            height: 20,
          ),
        if (this.status == 'Confirmed')
          Text(
            "You have been alloted the branch:",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        if (this.status == "Confirmed")
          SizedBox(
            height: 20,
          ),
        if (this.status == 'Confirmed')
          Text(
            this.branchName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50,
              color: Colors.green,
            ),
          ),
        if (this.status == "In Review")
          SizedBox(
            height: 100,
          ),
        if (this.status == "In Review")
          Text(
            "Your application status will change once your application is reviewed and you are alloted a branch according to your preference and qualifications.",
            style: TextStyle(fontSize: 18),
          )
      ],
    );
  }
}
