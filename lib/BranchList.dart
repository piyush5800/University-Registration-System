import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BranchList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    QuerySnapshot branchData = arguments['branchData'];
    return Scaffold(
      appBar: AppBar(
        title: Text("Branches Offered"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: BranchListBody(
              branchData: branchData,
            ),
          ),
        ),
      ),
    );
  }
}

class BranchListBody extends StatefulWidget {
  BranchListBody({this.branchData});
  final QuerySnapshot branchData;

  @override
  _BranchListBodyState createState() => _BranchListBodyState();
}

class _BranchListBodyState extends State<BranchListBody> {
  List<Widget> branches;

  List<Widget> buildBranchList() {
    List<Widget> branchList = List<Widget>();
    for (int i = 0; i < this.widget.branchData.size; i++) {
      branchList.add(
        Card(
          elevation: 3.0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  this.widget.branchData.docs[i]['name'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  height: 1,
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text(
                    "Head: ${this.widget.branchData.docs[i]['head']}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text(
                    "Number of seats: ${this.widget.branchData.docs[i]['maxSeats']}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text(
                    "Code: ${this.widget.branchData.docs[i]['code']}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text(
                    "Department: ${this.widget.branchData.docs[i]['department']}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return branchList;
  }

  @override
  Widget build(BuildContext context) {
    this.branches = buildBranchList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: this.branches,
    );
  }
}
