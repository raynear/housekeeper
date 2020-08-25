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

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    var widgetList = <Widget>[];

    return Scaffold(
      appBar: AppBar(title: Text('House')),
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
                  child: Column(
                      children: [Text(data['name']), Text(data['address'])]));
            },
          ),
          StreamBuilder(
            stream: rooms.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('ERROR');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...');
              }
              if (!snapshot.hasData) return LinearProgressIndicator();

              snapshot.data.docs.forEach((doc) {
                var optionWidget = <Widget>[];
                doc.data()['options'].forEach((option) async {
                  print('option $option');

                  optionWidget.add(FutureBuilder(
                      future: options.doc(option).get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('ERROR ${snapshot.error}');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Loading...');
                        }
                        if (!snapshot.hasData) {
                          return LinearProgressIndicator();
                        }
                        var data = snapshot.data.data();

                        print('future $data');
                        return Column(
                          children: [
                            Text(data['photo'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
//                          Text(item.data()['purchase'].toString()),
                            Text(data['type']),
                          ],
                        );
                      }));
                });
                print(options);
                widgetList.add(ListTile(
                    title: Text(doc.data()['name']),
                    subtitle: Column(children: optionWidget)));
              });

              return ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(10.0),
                children: widgetList,
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
                            rooms.add(
                                {'name': nameController.text, 'options': []});
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
