import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notepad/addNewSub.dart';
import 'package:notepad/note_view.dart';
class NoteView extends StatefulWidget {
  NoteView({super.key,required this.title});
  var title;

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  TextEditingController addsubcontroller=TextEditingController();

  var data;

  recData()async{
    var dataList=[];

    try{
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('NotePad');
      QuerySnapshot querySnapshot = await collectionReference.get();
      var num=querySnapshot.docs.length;
      print( 'num=$num');
      DocumentSnapshot snapshot = await collectionReference.doc(widget.title).get();
      data = await snapshot.data() as Map;
      dataList=data.keys.toList();
      print('NOTE3=$data');
    }catch(e){
      print('Error : $e');
    }
    print('Doc list = $data');
    setState(() {

    });
    return dataList;
  }
  @override
  void initState() {
    recData();
    super.initState();
  }
  void deleteCard(String cardTitle) async {
    try {
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('NotePad');
      await collectionReference.doc(widget.title).update({
        cardTitle: FieldValue.delete(),
      });
      recData();
    } catch (e) {
      print('Error deleting card: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title:   Text(widget.title,style:GoogleFonts.titanOne(
            textStyle: TextStyle(fontSize: 26,color: Colors.black)
        ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25),topRight: Radius.circular(25),topLeft: Radius.circular(25)
              ),
              gradient: LinearGradient(
                  colors: [Colors.white70,Colors.white],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter
              ),
              border: Border.all(width: 1.5,color: Colors.black54)
          ),
        ),


      ),
      body:FutureBuilder(
        future: recData(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            var data1 = snapshot.data as List;
            print('Data print=$data1');
            return Container(
              child: ListView.builder(
                  itemCount: data1.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                          title: Text(data1[index]),
                          onTap: (){
                            var note = data1[index];
                            //print('Note= $note');
                            print('Note = ${data[note]}');
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SubFile(note: data[note], subt: data1[index], title: widget.title)));
                          },
                          trailing: IconButton(
                            onPressed: (){
                              setState(() {
                                deleteCard(data1[index]);
                              });
                            }, icon: Icon(Icons.delete),

                          ),
                        )
                    );
                  }
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context,
              builder: (context){
                return Container(
                  child: AlertDialog(
                    title: TextField(
                      controller: addsubcontroller,
                      decoration: InputDecoration(
                          hintText: 'Enter new subtitle'
                      ),
                    ),
                    actions: [
                      TextButton(onPressed: (){
                        if(addsubcontroller.text.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(10),
                                  content: Text("require a subtitle")));
                          return;
                        }
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Body(subtitle: addsubcontroller.text,title:widget.title))).then((value) =>
                            recData());

                      }, child: Text('create')
                      ),
                      TextButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, child: Text('cancel'))
                    ],
                  ),
                );
              });
        },
        child: Icon(Icons.add),

      ),
    );
  }
}
