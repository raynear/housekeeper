import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:housekeeper/global_state.dart';

class RoomCard extends StatelessWidget {
  RoomCard({Key key, @required this.data, @required this.showButtons});

  final Map<String, dynamic> data;
  final bool showButtons;
  final CollectionReference houses = FirebaseFirestore.instance
      .collection('housekeeper')
      .doc(user.value.uid)
      .collection('houses');

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
        onTap: () {
          print(data);
          Get.toNamed('/house', arguments: data['documentID']);
        },
        child: Card(
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'],
                                style: theme.textTheme.headline6,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                data['address'],
                                style: theme.textTheme.subtitle1,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ],
                          ),
                          Visibility(
                              maintainAnimation: true,
                              maintainSize: true,
                              maintainState: true,
                              visible: showButtons,
                              child: Row(
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Get.toNamed('/house/edit',
                                          arguments: data['documentID']);
                                    },
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      houses
                                          .doc(data['documentID'])
                                          .collection('rooms')
                                          .get()
                                          .then((snapshot) {
                                        for (DocumentSnapshot ds
                                            in snapshot.docs) {
                                          ds.reference.delete();
                                        }
                                      });
                                      houses.doc(data['documentID']).delete();
                                    },
                                  ),
                                ],
                              ))
                        ]),
                    Divider(
                      thickness: 1.5,
                      indent: 8.0,
                      endIndent: 8.0,
                    ),
                    Text(
                        'blablablablablablablablablablablablablablablablablablablablablablablablablablablablablablablablablablablablablablablablablabla',
                        style: theme.textTheme.bodyText2),
                  ],
                ))));
  }
}
