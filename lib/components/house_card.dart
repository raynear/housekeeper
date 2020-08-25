import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:housekeeper/global_state.dart';

class HouseCard extends StatefulWidget {
  final Map<String, dynamic> data;
  HouseCard({Key key, @required this.data}) : super(key: key);

  @override
  _HouseCardState createState() => _HouseCardState();
}

class _HouseCardState extends State<HouseCard> {
  CollectionReference houses = FirebaseFirestore.instance
      .collection('housekeeper')
      .doc(user.value.uid)
      .collection('houses');
  var showButtons = false;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
        onTap: () {
          print(widget.data);
          Get.toNamed('/house', arguments: widget.data['documentID']);
        },
        onLongPress: () {
          setState(() {
            showButtons = !showButtons;
          });
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
                              Text(widget.data['name'],
                                  style: theme.textTheme.headline6),
                              Text(
                                widget.data['address'],
                                style: theme.textTheme.subtitle1,
                                overflow: TextOverflow.fade,
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
                                      print('move to edit window');
                                      Get.toNamed('/house/edit',
                                          arguments: widget.data['documentID']);
                                    },
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      print('delete house');
                                      houses
                                          .doc(widget.data['documentID'])
                                          .delete();
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
