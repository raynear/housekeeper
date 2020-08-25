import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:housekeeper/global_state.dart';
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
//  CollectionReference houses = FirebaseFirestore.instance.collection('houses');
//  var batch = FirebaseFirestore.instance.batch();

  // @override
  // void dispose() {
  //   nameController.dispose();
  //   addressController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[];

    if (user.value == null) {
      return Scaffold(
          appBar: AppBar(title: Text('Have to Sign in')),
          body: Column(children: [Text('go to sign in')]));
    }
    return Scaffold(
      appBar: AppBar(title: Text('House List')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
              stream: housekeeper
                  .doc(user.value.uid)
                  .collection('houses')
                  .snapshots(includeMetadataChanges: true),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('ERROR');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                }
                if (!snapshot.hasData) return LinearProgressIndicator();

                snapshot.data.docs.forEach((doc) {
                  widgetList.add(ListTile(
                      title: Text(doc.data()['name']),
                      subtitle: Text(doc.data()['address']),
                      onTap: () {
                        print(doc.data());
                        Get.toNamed('/house', arguments: doc.documentID);
                      }));
                });

                print(widgetList);

                return ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  children: widgetList,
                );
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
                          decoration: InputDecoration(hintText: 'address'),
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
      ),
    );
  }
}
