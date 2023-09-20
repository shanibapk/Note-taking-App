import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class CreateNote extends StatefulWidget {
  CreateNote({super.key,required this.title});
  String title='';


  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {

  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final bodyController = TextEditingController();

  sendData(String noteSubTitle)async{
    try{
      await FirebaseFirestore.instance.collection('NotePad2').doc('subtitle').set({'noteSubTitle':noteSubTitle});
    }catch(e){
      print('Sending error = $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title:  Text("Create Your Notes",style:GoogleFonts.titanOne(
            textStyle: TextStyle(fontSize: 26,color: Colors.black)
        ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25),topLeft: Radius.circular(25),topRight: Radius.circular(25)
              ),
              gradient: LinearGradient(
                  colors: [Colors.white70,Colors.white],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter
              ),
              border: Border.all(width: 1.5,color: Colors.grey)


          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Center(
                child: Text(widget.title,
                  style: GoogleFonts.lobster(
                      textStyle: TextStyle(fontSize: 25)
                  ),
                )
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: subtitleController,
              style: const TextStyle(
                  fontSize: 25,
                  color:Colors.black
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Subtitle",
                hintStyle: TextStyle(color: Colors.grey),

              ),
            ),
            const SizedBox(height: 10,),
            TextFormField(
              controller: bodyController,
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(
                  fontSize: 18,
                  color:Colors.black
              ),
              decoration: const InputDecoration(

                border: InputBorder.none,
                hintText: "Your Story",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          save();

          print('button pressed');

          // sendData(subtitleController.text);
          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
  void save()async{

    var TITLE=widget.title;
    print('TITLE=$TITLE');
    var SUBTITLE=subtitleController.text;
    print('SUBTITLE=$SUBTITLE');
    var BODY=bodyController.text;
    print('BODY=$BODY');
    try{
      await FirebaseFirestore.instance.collection('NotePad').doc(widget.title).set({subtitleController.text: bodyController.text});
    }catch(e){
      print('error=$e');
    }
  }

}