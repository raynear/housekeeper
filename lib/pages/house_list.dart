import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HouseList extends StatefulWidget {
  HouseList({Key key}) : super(key: key);

  @override
  _HouseListState createState() => _HouseListState();
}

class _HouseListState extends State<HouseList> {
  final _name = TextEditingController();
  CollectionReference coll =
      FirebaseFirestore.instance.collection('housekeeper');
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
                onPressed: () {
                  coll.add({'name': 'raynear', 'age': 41}).then((value) {
                    print(value);
                  });
                })
          ],
        ));
  }
}
