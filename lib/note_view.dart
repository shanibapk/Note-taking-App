import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
class SubFile extends StatefulWidget {
  SubFile({super.key, required this.note, required this.subt, required this.title});

  var note;
  var subt;
  var title;

  @override
  State<SubFile> createState() => _SubFileState();
}

class _SubFileState extends State<SubFile> {
  bool edit = true;
  TextEditingController nte = TextEditingController();
  Color selectedColor = Colors.white; // Default page background color

  void _openColorPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Page Background Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  selectedColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Apply'),
              onPressed: () {
                // You can save the selectedColor value in your database or use it as needed.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    recData();
    super.initState();
  }

  recData() async {
    var dataList2 = [];
    try {
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('NotePad');
      // ... your existing code for fetching data
      nte.text = widget.note;
    } catch (e) {
      print('Error : $e');
    }
    return dataList2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selectedColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.subt,
          style: GoogleFonts.titanOne(
            textStyle: TextStyle(fontSize: 23, color: Colors.black),
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
            gradient: LinearGradient(
              colors: [Colors.white70, Colors.white],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            border: Border.all(width: 1.5, color: Colors.black54),
          ),
        ),
        actions: [
          edit
              ? IconButton(
            onPressed: _openColorPickerDialog,
            icon: Icon(Icons.color_lens),
          )
              : SizedBox(),
          edit
              ? Icon(
            Icons.add,
            color: Colors.white,
          )
              : IconButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('NotePad').doc(widget.title).update(
                  {widget.subt: nte.text});
              Navigator.pop(context);
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: FutureBuilder(
        future: recData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: nte,
                onTap: () {
                  setState(() {
                    edit = false;
                  });
                },
                readOnly: edit,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
