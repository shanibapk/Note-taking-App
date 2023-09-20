import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Body extends StatefulWidget {
  Body({super.key,required this.subtitle,required this.title});
  var subtitle;
  var title;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController newbodyController=TextEditingController();
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
                child: Text(widget.subtitle,
                  style: GoogleFonts.lobster(
                      textStyle: TextStyle(fontSize: 25)
                  ),
                )
            ),
            SizedBox(
              height: 10,
            ),

            const SizedBox(height: 10,),
            TextFormField(
              controller: newbodyController,
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
          subSave();

          print('button pressed');

          // sendData(subtitleController.text);
          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }
  void subSave()async{
    try{
      FirebaseFirestore.instance.collection('NotePad').doc(widget.title).update({widget.subtitle:newbodyController.text});
    }catch(e){
      print('error=$e');
    }
  }
}
