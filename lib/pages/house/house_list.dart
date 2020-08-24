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
    if (user.value == null) {
      return Scaffold(
          appBar: AppBar(title: Text('Have to Sign in')),
          body: Column(children: [Text('go to sign in')]));
    }
    return Scaffold(
        appBar: AppBar(title: Text('Add House')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
                stream: housekeeper
                    .doc(user.value.uid)
                    .collection('houses')
                    .snapshots(),
                builder: (context, snapshot) {
                  print(snapshot.connectionState.toString());
                  print(snapshot.toString());
                  print(snapshot.data.toString());
                  if (!snapshot.hasError) {
                    return Text('ERROR');
                  }
                  if (!snapshot.hasData) return LinearProgressIndicator();

                  return ListView(
                    children: snapshot.data.docs.map((doc) {
                      return ListTile(
                        title: Text(doc.data()['name']),
                        subtitle: Text(doc.data()['address']),
                      );
                    }).toList(),
                  );
                }),
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

                  var bb = await housekeeper
                      .doc(user.value.uid)
                      .collection('houses')
                      .snapshots();
                  print(bb);
                  await bb.first.then((item) async {
                    await item.docs.forEach((element) async {
                      print(element.data());
                    });
                  });

                  var abcd = await housekeeper
                      .doc(user.value?.uid)
                      .collection('houses')
                      .get();

                  abcd.docs.forEach((element) {
                    housekeeper
                        .doc(user.value?.uid)
                        .collection('houses')
                        .doc(element.id)
                        .collection('rooms')
                        .get()
                        .then((elm) {
                      elm.docs.forEach((elm2) {
                        print(elm2.data());
                      });
                    });
                    print(element.data());
                  });
                }
                // coll.add({'name': 'raynear', 'age': 41}).then((value) {
                //   print(value);
                // });
                )
          ],
        ));
  }
}
