import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:housekeeper/global_state.dart';

class House extends StatefulWidget {
  House({Key key}) : super(key: key);

  @override
  _HouseState createState() => _HouseState();
}

class _HouseState extends State<House> {
  CollectionReference house = FirebaseFirestore.instance
      .collection('housekeeper')
      .doc(user.value.uid)
      .collection('houses');
//      .doc(Get.arguments);

  CollectionReference rooms = FirebaseFirestore.instance
      .collection('housekeeper')
      .doc(user.value.uid)
      .collection('houses')
      .doc(Get.arguments)
      .collection('rooms');
  CollectionReference options =
      FirebaseFirestore.instance.collection('options');

  var setting = false;

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

//    var widgetList = <Widget>[];

    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('House'), actions: [
        GestureDetector(
            onTap: () {
              print('change setting $setting');
              setState(() {
                setting = setting ? false : true;
              });
            },
            child: Padding(
                padding: EdgeInsets.all(8.0), child: Icon(Icons.settings)))
      ]),
      body: ListView(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: house.doc(Get.arguments).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('ERROR ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...');
              }
              if (!snapshot.hasData) return LinearProgressIndicator();

              print('argument ${Get.arguments}');

              var data = snapshot.data.data();

              print('snapshot $data');
              return Card(
                  color: Colors.blue[50],
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['name'],
                                style: theme.textTheme.headline6),
                            Text(data['address'],
                                style: theme.textTheme.subtitle1)
                          ])));
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: rooms.orderBy('name').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('ERROR');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...');
              }
              if (!snapshot.hasData) return LinearProgressIndicator();

              return ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(10.0),
                children: snapshot.data.docs.map((doc) {
                  var data = doc.data();
                  return GestureDetector(
                      child: Card(
                        child: ListTile(
                          title: Text(data['name']),
                          subtitle: Column(children: []),
                        ),
                      ),
                      onTap: () {
                        data['house'] = Get.arguments;
                        data['room'] = doc.id;
                        Get.toNamed('room', arguments: data);
                      });
                }).toList(),
              );
            },
          )
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
                          title: Text('Add Room'),
                          content: Column(
                            children: [
                              TextField(
                                controller: nameController,
                                decoration: InputDecoration(hintText: 'name'),
                              ),
                              RaisedButton(
                                child: Text('Submit'),
                                onPressed: () {
                                  rooms.add({
                                    'name': nameController.text,
                                    'options': []
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
