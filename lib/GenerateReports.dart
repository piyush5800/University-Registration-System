import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GenerateReports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Generate Reports"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: GenerateReportsBody(),
          ),
        ),
      ),
    );
  }
}

class GenerateReportsBody extends StatefulWidget {
  @override
  _GenerateReportsBodyState createState() => _GenerateReportsBodyState();
}

class _GenerateReportsBodyState extends State<GenerateReportsBody> {
  bool isFetched = false;
  String dropDownValue = "1st choice branch distribution";
  List<Widget> displayData;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Please select the type of report you want to display.",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Column(
          children: [
            Container(
              width: 400,
              child: DropdownButtonFormField(
                value: this.dropDownValue,
                items: [
                  DropdownMenuItem(
                    child: Text("1st choice branch distribution"),
                    value: "1st choice branch distribution",
                  ),
                  DropdownMenuItem(
                    child: Text("List of branches"),
                    value: "List of branches",
                  ),
                  DropdownMenuItem(
                    child: Text("List of branch heads"),
                    value: "List of branch heads",
                  ),
                  DropdownMenuItem(
                    child: Text("List of students by name"),
                    value: "List of students by name",
                  ),
                ],
                onChanged: (String newValue) {
                  setState(() {
                    this.dropDownValue = newValue;
                  });
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 400,
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                ),
                onPressed: () async {
                  await Firebase.initializeApp();

                  if (this.dropDownValue == "1st choice branch distribution") {
                    try {
                      this.displayData = List<Widget>();
                      Map<String, int> temp = Map<String, int>();

                      QuerySnapshot allData = await FirebaseFirestore.instance
                          .collection('students')
                          .get();

                      for (int i = 0; i < allData.size; i++) {
                        if (temp.containsKey(allData.docs[i]['choice1'])) {
                          temp[allData.docs[i]['choice1']] += 1;
                        } else {
                          temp.addEntries(
                              [MapEntry(allData.docs[i]['choice1'], 1)]);
                        }
                      }
                      int counter = 0;
                      temp.forEach((key, value) {
                        counter++;
                        this.displayData.add(
                              Container(
                                child: Text(
                                  "$counter. ${key.toUpperCase()} : $value",
                                  style: TextStyle(fontSize: 24),
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
                  } else if (this.dropDownValue == "List of branches") {
                    try {
                      this.displayData = List<Widget>();
                      Set<String> temp = Set<String>();

                      QuerySnapshot allData = await FirebaseFirestore.instance
                          .collection('branches')
                          .get();

                      for (int i = 0; i < allData.size; i++) {
                        temp.add(allData.docs[i]['name']);
                      }
                      int counter = 0;
                      temp.forEach((key) {
                        counter++;
                        this.displayData.add(
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Container(
                                  child: Text(
                                    "$counter. $key",
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
                  } else if (this.dropDownValue == "List of branch heads") {
                    try {
                      this.displayData = List<Widget>();
                      Set<String> temp = Set<String>();

                      QuerySnapshot allData = await FirebaseFirestore.instance
                          .collection('branches')
                          .get();

                      for (int i = 0; i < allData.size; i++) {
                        temp.add(allData.docs[i]['head']);
                      }
                      int counter = 0;
                      temp.forEach((key) {
                        counter++;
                        this.displayData.add(
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Container(
                                  child: Text(
                                    "$counter. $key",
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
                  } else if (this.dropDownValue == "List of students by name") {
                    try {
                      this.displayData = List<Widget>();
                      Set<String> temp = Set<String>();

                      QuerySnapshot allData = await FirebaseFirestore.instance
                          .collection('students')
                          .get();

                      for (int i = 0; i < allData.size; i++) {
                        temp.add(allData.docs[i]['firstName'] +
                            " " +
                            allData.docs[i]['lastName']);
                      }
                      int counter = 0;
                      temp.forEach((key) {
                        counter++;
                        this.displayData.add(
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Container(
                                  child: Text(
                                    "$counter. $key",
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
                  }
                },
                child: Text(
                  "Create Report",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Generated Report",
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
                children: this.displayData,
                crossAxisAlignment: CrossAxisAlignment.stretch,
              ),
          ],
        ),
      ],
    );
  }
}
