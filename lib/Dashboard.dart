import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    DocumentSnapshot userData = arguments['data'];
    String role = arguments['role'];
    String uid = arguments['uid'];
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text("Dashboard"),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              })
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Text(
                    "Hello ${userData["firstName"]},",
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (role == "admin" || role == "DEO")
                  DashboardCard(
                      title: "View Student Details",
                      description:
                          "View the details of an applicant using registered email address.",
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/dashboard/viewStudentDetails');
                      }),
                if (role == "admin" || role == "DEO")
                  DashboardCard(
                      title: "Add Student Details",
                      description:
                          "Add the details of a new applicant from the administrator console.",
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/dashboard/addStudentDetails');
                      }),
                if (role == "admin" || role == "DEO")
                  DashboardCard(
                      title: "Edit Student Details",
                      description:
                          "Edit the details of an applicant whose details already exist in the system.",
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/dashboard/editStudentDetails');
                      }),
                if (role == "admin" || role == "DEO")
                  DashboardCard(
                      title: "Delete Student Details",
                      description:
                          "Delete the details of an applicant whose details already exist in the system.",
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/dashboard/deleteStudentDetails');
                      }),
                if (role == "DEO" || role == "admin")
                  DashboardCard(
                      title: "View Branch Details",
                      description:
                          "View the details of a branch using branch code.",
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/dashboard/viewBranchDetails');
                      }),
                if (role == "DEO" || role == "admin")
                  DashboardCard(
                      title: "Add Branch Details",
                      description:
                          "Add the details of a new branch from the DEO console.",
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/dashboard/addBranchDetails');
                      }),
                if (role == "DEO" || role == "admin")
                  DashboardCard(
                      title: "Edit Branch Details",
                      description:
                          "Edit the details of a branch whose details already exist in the system.",
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/dashboard/editBranchDetails');
                      }),
                if (role == "DEO" || role == "admin")
                  DashboardCard(
                      title: "Delete Branch Details",
                      description:
                          "Delete the details of a branch whose details already exist in the system.",
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/dashboard/deleteBranchDetails');
                      }),
                if (role == "student")
                  DashboardCard(
                    title: "View submitted application",
                    description:
                        "Print the submitted application as stored in the database.",
                    onPressed: () async {
                      DocumentSnapshot userData = await FirebaseFirestore
                          .instance
                          .collection('students')
                          .doc(uid)
                          .get();
                      Navigator.pushNamed(
                        context,
                        '/dashboard/submittedApplication',
                        arguments: {'data': userData},
                      );
                    },
                  ),
                if (role == "student")
                  DashboardCard(
                    title: "Check Application Status",
                    description:
                        "Check the status of your submitted application.",
                    onPressed: () async {
                      try {
                        DocumentSnapshot userData = await FirebaseFirestore
                            .instance
                            .collection('applications')
                            .doc(uid)
                            .get();
                        QuerySnapshot tempData = await FirebaseFirestore
                            .instance
                            .collection('branches')
                            .where('code',
                                isEqualTo: userData['allotedBranch']
                                    .toString()
                                    .toUpperCase())
                            .get();
                        if (tempData.size > 0) {
                          String branchNameData = tempData.docs[0]['name'];
                          Navigator.pushNamed(
                              context, '/dashboard/applicationStatus',
                              arguments: {
                                'status': userData['status'],
                                'allotedBranch': userData['allotedBranch'],
                                'branchName': branchNameData,
                              });
                        } else {
                          Navigator.pushNamed(
                              context, '/dashboard/applicationStatus',
                              arguments: {
                                'status': userData['status'],
                                'allotedBranch': userData['allotedBranch'],
                                'branchName': "",
                              });
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                if (role == "admin")
                  DashboardCard(
                    title: "Generate Reports",
                    description:
                        "Generate reports from the current data stored in the system.",
                    onPressed: () {
                      Navigator.pushNamed(
                          context, '/dashboard/generateReports');
                    },
                  ),
                if (role == "admin")
                  DashboardCard(
                    title: "Allot Branches",
                    description:
                        "Run the allotment algorithm to allot the branches to the students.",
                    onPressed: () {
                      Navigator.pushNamed(context, '/dashboard/allotBranches');
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String description;
  final Function onPressed;
  DashboardCard({this.title, this.description, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              this.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              this.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FractionallySizedBox(
              widthFactor: 0.3,
              child: RaisedButton(
                onPressed: this.onPressed,
                child: Text("Proceed"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
