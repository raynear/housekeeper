import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:housekeeper/global_state.dart';

class HouseList extends StatefulWidget {
  HouseList({Key key}) : super(key: key);

  @override
  _HouseListState createState() => _HouseListState();
}

class _HouseListState extends State<HouseList> {
  final _name = TextEditingController();
  CollectionReference housekeeper =
      FirebaseFirestore.instance.collection('housekeeper');
  CollectionReference houses = FirebaseFirestore.instance.collection('houses');
//  var batch = FirebaseFirestore.instance.batch();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add House')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _name,
              onSubmitted: (name) {
                _name.clear();
              },
            ),
            RaisedButton(
                child: Text('제출'),
                onPressed: () async {
                  print(user.value.uid);
                  await housekeeper
                      .where('uid', isEqualTo: user.value?.uid)
                      .get()
                      .then((snapshot) async {
                    snapshot.docs.forEach((doc) async {
                      housekeeper
                          .doc(doc.data()['house'])
                          .collection('houses')
                          .doc()
                          .get()
                          .then((aa) {
                        print('test11111 ${aa.data()}');
                      });
                      print('house ${doc.data()['house']}');
                      var aHouse = await houses
                          .where('id', isEqualTo: doc.data()['house'])
                          .get();
                      print('aHouse $aHouse');
                      aHouse.docs.forEach((element) {
                        print('aaa ${element.data()}');
                      });
                    });
                  });
                  // coll.add({'name': 'raynear', 'age': 41}).then((value) {
                  //   print(value);
                  // });
                })
          ],
        ));
  }
}
