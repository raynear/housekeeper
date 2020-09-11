import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:housekeeper/components/new_contract_dialog.dart';
// import 'package:housekeeper/global_state.dart';

class Room extends StatefulWidget {
  Room({Key key}) : super(key: key);

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  var setting = false;

  var argument = Map<String, dynamic>.from(Get.arguments);

  DocumentReference contract = FirebaseFirestore.instance
      .collection('contract')
      .doc(Map<String, dynamic>.from(Get.arguments)['contract']);

  @override
  Widget build(BuildContext context) {
    print(argument);
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('House'), actions: [
        GestureDetector(
            onTap: () {
              setState(() {
                setting = setting ? false : true;
              });
            },
            child: Padding(
                padding: EdgeInsets.all(8.0), child: Icon(Icons.settings)))
      ]),
      body: Card(
          margin: EdgeInsets.all(8),
          child: Padding(
              padding: EdgeInsets.all(8),
              child: FutureBuilder<DocumentSnapshot>(
                future: contract.get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('ERROR');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Loading...');
                  }
                  if (!snapshot.hasData) return LinearProgressIndicator();

                  print(snapshot.data.data());
                  var roomContract = snapshot.data.data();

                  print(argument['options']);

                  return Column(children: [
                    ListTile(
                      title: Text(
                        argument['name'],
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headline4,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ' + roomContract['tenant'],
                              style: theme.textTheme.bodyText1),
                          Text('Deposit: ' + roomContract['deposit'].toString(),
                              style: theme.textTheme.bodyText1),
                          Text('Rent: ' + roomContract['rent'].toString(),
                              style: theme.textTheme.bodyText1),
                          Text('Contract: ' + roomContract['contract'],
                              style: theme.textTheme.bodyText1),
                          Text(
                              'Date: ' +
                                  DateFormat('yyyy-MM-dd')
                                      .format(roomContract['due'].toDate()),
                              style: theme.textTheme.bodyText1),
                        ],
                      ),
                    ),
                    Column(
                      children: [Text('test')],
                    )
                  ]);
                },
              ))),
      floatingActionButton: setting
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Get.snackbar('add', 'add options');
                showDialog(
                    context: context,
                    builder: (context) {
                      return NewContractDialog(
                          house: argument['house'], room: argument['room']);
                    });
              },
            )
          : Container(),
    );
  }
}
