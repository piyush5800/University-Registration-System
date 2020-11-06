import 'package:flutter/material.dart';
import 'RegistrationConfirm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ViewBranchDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Branch Details"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: ViewBranchDetailsBody(),
          ),
        ),
      ),
    );
  }
}

class ViewBranchDetailsBody extends StatefulWidget {
  @override
  _ViewBranchDetailsBodyState createState() => _ViewBranchDetailsBodyState();
}

class _ViewBranchDetailsBodyState extends State<ViewBranchDetailsBody> {
  final _formKey = GlobalKey<FormState>();
  DocumentSnapshot branchData;
  bool isFetched = false;
  String branchCode;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Please enter the branch code of the branch you want to view.",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: 400,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter the branch code";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    this.branchCode = value;
                  },
                  autocorrect: false,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Branch Code",
                    contentPadding: EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18.0)),
                    ),
                  ),
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
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      QuerySnapshot allData = await FirebaseFirestore.instance
                          .collection("branches")
                          .where('code', isEqualTo: this.branchCode)
                          .get();

                      if (allData.size > 0) {
                        setState(() {
                          this.branchData = allData.docs[0];

                          print("Record Found for ${this.branchData['name']}");

                          this.isFetched = true;
                        });
                      } else {
                        final snackBar = SnackBar(
                            content: Text(
                                "No Record exists for the entered branch code."));
                        Scaffold.of(context).showSnackBar(snackBar);
                        setState(() {
                          this.isFetched = false;
                        });
                      }
                    }
                  },
                  child: Text(
                    "Fetch Details",
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
              if (this.isFetched) BranchDetails(branchData: this.branchData),
            ],
          ),
        ),
      ],
    );
  }
}

class BranchDetails extends StatelessWidget {
  final DocumentSnapshot branchData;
  BranchDetails({this.branchData});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConfirmationItem(
          title: "Branch Name",
          data: this.branchData['name'],
        ),
        ConfirmationItem(
          title: "Branch Code",
          data: this.branchData['code'],
        ),
        ConfirmationItem(
          title: "Branch Head",
          data: this.branchData['head'],
        ),
        ConfirmationItem(
          title: "Number of Seats",
          data: this.branchData['maxSeats'].toString(),
        ),
        ConfirmationItem(
          title: "Department",
          data: this.branchData['department'],
        ),
      ],
    );
  }
}
