import 'package:flutter/material.dart';
import 'Login.dart';
import 'Dashboard.dart';
import 'NewRegistration.dart';
import 'RegistrationConfirm.dart';
import 'RegistrationSuccess.dart';
import 'AddBranchDetails.dart';
import 'AddStudentDetails.dart';
import 'ViewStudentDetails.dart';
import 'ViewBranchDetails.dart';
import 'DeleteBranchDetails.dart';
import 'DeleteStudentDetails.dart';
import 'EditBranchDetails.dart';
import 'EditStudentDetails.dart';
import 'ApplicationStatus.dart';
import 'BranchList.dart';
import 'GenerateReports.dart';
import 'AllotBranches.dart';
import 'SubmittedApplication.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => Login(),
        '/newEnrolment': (context) => NewRegistration(),
        '/dashboard': (context) => Dashboard(),
        '/registrationConfirm': (context) => RegistrationConfirm(),
        '/registrationSuccess': (context) => RegistrationSuccess(),
        '/dashboard/viewStudentDetails': (context) => ViewStudentDetails(),
        '/dashboard/editStudentDetails': (context) => EditStudentDetails(),
        '/dashboard/addStudentDetails': (context) => AddStudentDetails(),
        '/dashboard/deleteStudentDetails': (context) => DeleteStudentDetails(),
        '/dashboard/viewBranchDetails': (context) => ViewBranchDetails(),
        '/dashboard/editBranchDetails': (context) => EditBranchDetails(),
        '/dashboard/addBranchDetails': (context) => AddBranchDetails(),
        '/dashboard/deleteBranchDetails': (context) => DeleteBranchDetails(),
        '/dashboard/applicationStatus': (context) => ApplicationStatus(),
        '/branchList': (context) => BranchList(),
        '/dashboard/generateReports': (context) => GenerateReports(),
        '/dashboard/allotBranches': (context) => AllotBranches(),
        '/dashboard/submittedApplication': (context) => SubmittedApplication(),
      },
    );
  }
}
