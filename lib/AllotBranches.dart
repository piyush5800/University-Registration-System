import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class AllotBranches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Allot Branches"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: AllotBranchesBody(),
          ),
        ),
      ),
    );
  }
}

class AllotBranchesBody extends StatefulWidget {
  @override
  _AllotBranchesBodyState createState() => _AllotBranchesBodyState();
}

class _AllotBranchesBodyState extends State<AllotBranchesBody> {
  Map<String, String> allotedBranches;
  List<Widget> displayData;
  bool isFetched = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Once you click the button below, the branches will be alloted to the students in order of their preference and on basis of availability and their profile. Please click the button to proceed.",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: 300,
          child: RaisedButton(
            onPressed: () async {
              try {
                this.allotedBranches = Map<String, String>();
                this.displayData = List<Widget>();
                await Firebase.initializeApp();
                QuerySnapshot studentData = await FirebaseFirestore.instance
                    .collection('students')
                    .get();
                QuerySnapshot applicationData = await FirebaseFirestore.instance
                    .collection('applications')
                    .get();

                for (int i = 0; i < applicationData.size; i++) {
                  String tempBranch;
                  var list = [
                    studentData.docs[i]['choice1'],
                    studentData.docs[i]['choice2'],
                    studentData.docs[i]['choice3']
                  ];

                  final _random = new Random();

                  tempBranch = list[_random.nextInt(list.length)];

                  await FirebaseFirestore.instance
                      .collection('applications')
                      .doc(studentData.docs[i].id)
                      .set(
                          {'status': 'Confirmed', 'allotedBranch': tempBranch});
                  this.allotedBranches.addEntries(
                      [MapEntry(studentData.docs[i]['email'], tempBranch)]);
                }
                int counter = 0;
                this.allotedBranches.forEach((key, value) {
                  counter++;
                  this.displayData.add(
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Container(
                            child: Text(
                              "$counter. $key : ${value.toUpperCase()}",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      );
                });
                setState(() {
                  this.isFetched = true;
                });
              } catch (e) {
                print(e);
              }
            },
            child: Text(
              "Proceed",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(18.0),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Alloted Branches",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        if (this.isFetched)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: this.displayData,
          )
      ],
    );
  }
}
