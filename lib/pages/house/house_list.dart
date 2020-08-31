import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firestore_ui/firestore_ui.dart';
//import 'package:get/get.dart';

import 'package:housekeeper/global_state.dart';
import 'package:housekeeper/components/house_card.dart';
// import 'package:housekeeper/pages/house/add_house.dart';

class HouseList extends StatefulWidget {
  HouseList({Key key}) : super(key: key);

  @override
  _HouseListState createState() => _HouseListState();
}

class _HouseListState extends State<HouseList> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  CollectionReference housekeeper =
      FirebaseFirestore.instance.collection('housekeeper');
  bool setting = false;

  @override
  Widget build(BuildContext context) {
    if (user.value == null) {
      return Scaffold(
          appBar: AppBar(title: Text('Have to Sign in')),
          body: Column(children: [Text('go to sign in')]));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('House List'),
        actions: [
          GestureDetector(
              onTap: () {
                print('change setting $setting');
                setState(() {
                  setting = setting ? false : true;
                });
              },
              child: Padding(
                  padding: EdgeInsets.all(8.0), child: Icon(Icons.settings)))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: housekeeper
                  .doc(user.value.uid)
                  .collection('houses')
                  .orderBy('name')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('ERROR');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                }
                if (!snapshot.hasData) return LinearProgressIndicator();

                // return FirestoreAnimatedList(
                //     shrinkWrap: true,
                //     debug: false,
                //     query: housekeeper.doc(user.value.uid).collection('houses'),
                //     onLoaded: (snapshot) => print('${snapshot.docs.length}'),
                //     itemBuilder: (
                //       BuildContext context,
                //       DocumentSnapshot snapshot,
                //       Animation<double> animation,
                //       int index,
                //     ) =>
                //         FadeTransition(
                //           opacity: animation,
                //           child: HouseCard(
                //             data: snapshot.data(),
                //           ),
                //         ));
                return ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  children: snapshot.data.docs.map((doc) {
                    var data = doc.data();
                    data['documentID'] = doc.id;
                    return HouseCard(
                      data: data,
                      showButtons: setting,
                    );
                  }).toList(),
                );
              }),
        ],
      ),
      floatingActionButton: setting
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          title: Text('Add House'),
                          content: Column(
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: InputDecoration(hintText: 'name'),
                              ),
                              TextField(
                                controller: addressController,
                                decoration:
                                    InputDecoration(hintText: 'address'),
                              ),
                              RaisedButton(
                                child: Text('Submit'),
                                onPressed: () {
                                  housekeeper
                                      .doc(user.value.uid)
                                      .collection('houses')
                                      .add({
                                    'name': nameController.text,
                                    'address': addressController.text
                                  });
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ));
                    });
              },
            )
          : Container(),
    );
  }
}
