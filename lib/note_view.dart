import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class SubFile extends StatefulWidget {
  SubFile({super.key,required this.note, required this.subt, required this.title});
  var note;
  var subt;
  var title;

  @override
  State<SubFile> createState() => _SubFileState();
}

class _SubFileState extends State<SubFile> {

  bool edit = true;
  TextEditingController nte = TextEditingController();

  recData()async{
    var dataList2=[];
    try{
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('NotePad');
      //QuerySnapshot querySnapshot = await collectionReference.doc().get();
      // var num2=querySnapshot.docs.length;
      //print('num2=$num2');
      // for( var i=0;i<num;i++) {
      //   final title = querySnapshot.docs[i].reference.id;
      //print(widget.subtittle);
      //DocumentSnapshot snapshot = await collectionReference.doc(widget.title).get();
      //var data = await snapshot.data() as Map;
      //dataList2=data.values.toList();
      //print('NOTE4:$data');
      //}
      nte.text = widget.note;
    }catch(e){
      print('Error : $e');
    }
    return dataList2;
  }
  @override
  void initState() {
    recData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:   Text(widget.subt,style:GoogleFonts.titanOne(
            textStyle: TextStyle(fontSize: 23,color: Colors.black)
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
        actions: [
          edit ? Icon(Icons.add, color: Colors.white,) : IconButton(onPressed: (){
            FirebaseFirestore.instance.collection('NotePad').doc(widget.title).update(
                {widget.subt:nte.text});
            Navigator.pop(context);
          }, icon: Icon(Icons.check))
        ],
      ),
      body:FutureBuilder(
        future: recData(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            //var data = snapshot.data as List;
            //print('Data print3=$data');
            return Container(
              child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: TextField(
                          controller: nte,
                          onTap: (){
                            setState(() {
                              edit = false;
                            });
                          },
                          readOnly: edit,
                          style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                              border: InputBorder.none
                          ),
                        ),
                      ),
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
    );
  }
}