import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  var dueController = TextEditingController();

  CollectionReference contract =
      FirebaseFirestore.instance.collection('contract');

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(title: Text('new contract'), children: [
      TextField(
        controller: nameController,
        decoration: InputDecoration(hintText: 'name'),
      ),
      TextField(
        controller: phoneController,
        decoration: InputDecoration(hintText: 'phone'),
      ),
      TextField(
        controller: depositController,
        decoration: InputDecoration(hintText: 'deposit'),
      ),
      TextField(
        controller: rentController,
        decoration: InputDecoration(hintText: 'rent'),
      ),
      TextField(
        controller: photoController,
        decoration: InputDecoration(hintText: 'photo'),
      ),
      TextField(
        controller: dueController,
        decoration: InputDecoration(hintText: 'due'),
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
            'due': dueController.text,
            'house': widget.house,
            'room': widget.room,
          });
          Navigator.pop(context);
        },
      )
    ]);
  }
}
