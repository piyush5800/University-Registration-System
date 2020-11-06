import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteBranchDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Branch Details"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: DeleteBranchDetailsBody(),
          ),
        ),
      ),
    );
  }
}

class DeleteBranchDetailsBody extends StatefulWidget {
  @override
  _DeleteBranchDetailsBodyState createState() =>
      _DeleteBranchDetailsBodyState();
}

class _DeleteBranchDetailsBodyState extends State<DeleteBranchDetailsBody> {
  final _formKey = GlobalKey<FormState>();

  String branchCode;

  DocumentSnapshot branchData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Please enter the branch code of the branch you want to delete.",
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
                        this.branchData = allData.docs[0];
                        await FirebaseFirestore.instance
                            .collection("branches")
                            .doc(branchData.id)
                            .delete();

                        final snackBar = SnackBar(
                            content: Text(
                                "Details deleted for ${branchData['name']}."));
                        Scaffold.of(context).showSnackBar(snackBar);
                        print("Record Found for ${this.branchData['name']}");
                      } else {
                        final snackBar = SnackBar(
                            content: Text(
                                "No Record exists for the entered branch code."));
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  child: Text(
                    "Delete Details",
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
            ],
          ),
        ),
      ],
    );
  }
}
