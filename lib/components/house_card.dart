import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:housekeeper/global_state.dart';

class HouseCard extends StatelessWidget {
  HouseCard({Key key, @required this.data, @required this.showButtons});

  final Map<String, dynamic> data;
  final bool showButtons;
  //     : super(key: key);

//   @override
//   _HouseCardState createState() => _HouseCardState();
// }

// class _HouseCardState extends State<HouseCard> {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      '호실: 18개',
                      style: theme.textTheme.bodyText2,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '월세: 450만원',
                      style: theme.textTheme.bodyText2,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '관리비: 40만원',
                      style: theme.textTheme.bodyText2,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '미납금 : 120만원(2개 호실)',
                      style: theme.textTheme.bodyText2,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '공실률: 5.3%',
                      style: theme.textTheme.bodyText2,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '연체율: 12.5%',
                      style: theme.textTheme.bodyText2,
                      textAlign: TextAlign.left,
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          child: Text('호실 목록'),
                          onPressed: () {
                            print('press 호실 목록');
                          },
                        ),
                        FlatButton(
                          child: Text('입금 목록'),
                          onPressed: () {
                            print('press 입금 목록');
                          },
                        ),
                        FlatButton(
                          child: Text('연체 목록'),
                          onPressed: () {
                            print('press 연체 목록');
                          },
                        ),
                      ],
                    )
                  ],
                ))));
  }
}
