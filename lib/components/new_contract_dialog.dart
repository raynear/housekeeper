import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

import 'dart:io';

//import 'package:housekeeper/global_state.dart';

class NewContractDialog extends StatefulWidget {
  final String house;
  final String room;

  NewContractDialog({Key key, @required this.house, @required this.room})
      : super(key: key);

  @override
  _NewContractDialogState createState() => _NewContractDialogState();
}

class _NewContractDialogState extends State<NewContractDialog> {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var depositController = TextEditingController();
  var rentController = TextEditingController();
  var photoController = TextEditingController();

  CollectionReference contract =
      FirebaseFirestore.instance.collection('contract');

  var startDate = DateTime.now();
  var endDate = DateTime.now().add(Duration(days: 365));
  File photo;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var phoneFormatter = MaskTextInputFormatter(mask: '###-####-####');

    return SimpleDialog(title: Text('new contract'), children: [
      Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                inputFormatters: [phoneFormatter],
              ),
              TextField(
                controller: depositController,
                decoration:
                    InputDecoration(labelText: 'Deposit', suffixText: '원'),
                keyboardType: TextInputType.number,
                inputFormatters: [ThousandsFormatter()],
              ),
              TextField(
                controller: rentController,
                decoration: InputDecoration(labelText: 'Rent', suffixText: '원'),
                keyboardType: TextInputType.number,
                inputFormatters: [ThousandsFormatter()],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Contract Photo: '),
                FlatButton(
                    onPressed: () async {
                      photo = await FilePicker.getFile(type: FileType.image);
                      print(photo.path);
                    },
                    child: Text('File'))
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Start Date: '),
                  FlatButton(
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true, onChanged: (_date) {
                          print('change $_date');
                        }, onConfirm: (_date) {
                          setState(() {
                            startDate = _date;
                            endDate = startDate.add(Duration(days: 364));
                          });
                          print('confirm $_date');
                        }, currentTime: startDate, locale: LocaleType.ko);
                      },
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(startDate),
                        style: theme.textTheme.button,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('End Date: '),
                  FlatButton(
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true, onChanged: (_date) {
                          print('change $_date');
                        }, onConfirm: (_date) {
                          setState(() {
                            endDate = _date;
                          });
                          print('confirm $_date');
                        }, currentTime: endDate, locale: LocaleType.ko);
                      },
                      child: Text(
                        DateFormat('yyyy-MM-dd').format(endDate),
                        style: theme.textTheme.button,
                      )),
                ],
              ),
              RaisedButton(
                child: Text('Submit'),
                onPressed: () {
                  contract.add({
                    'name': nameController.text,
                    'phone': phoneController.text,
                    'deposit': depositController.text,
                    'rent': rentController.text,
                    'photo': photoController.text,
                    'startDate': startDate.toString(),
                    'endDate': endDate.toString(),
                    'house': widget.house,
                    'room': widget.room,
                  });
                  Navigator.pop(context);
                },
              )
            ],
          ))
    ]);
  }
}
