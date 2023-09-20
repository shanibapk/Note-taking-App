import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notepad/signUp.dart';
import 'create_note.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'subtitle_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController txt = TextEditingController();
  List<String> notes = List.empty(growable: true);
  List keysMainList = [];
  late List<String> filteredNotes = [];
  Color iconColor = Colors.white;
  bool isSearching = false;

  getData() async {
    var dataList = [];
    List titleList = [];

    try {
      CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('NotePad');
      QuerySnapshot querySnapshot = await collectionReference.get();
      var num = querySnapshot.docs.length;
      for (var i = 0; i < num; i++) {
        final title = querySnapshot.docs[i].reference.id;
        titleList.add(title);
        print('TitleList=$titleList');
      }
    } catch (e) {
      print('Error : $e');
    }
    return titleList;
  }

  @override
  void initState() {
    super.initState();
  }

  void startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  void stopSearch() {
    setState(() {
      isSearching = false;
      txt.clear();
    });
  }

  void performSearch(String query) {
    setState(() {
      filteredNotes = notes.where((note) {
        return note.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }
  Future<void> toggleFavoriteStatus(String noteTitle, bool isFavorite) async {
    try {
      CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('NotePad');
      DocumentReference docRef = collectionReference.doc(noteTitle);
      await docRef.update({'isFavorite': !isFavorite});
    } catch (e) {
      print('Error updating favorite status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        backgroundColor: Colors.white,
        title: isSearching
            ? TextField(
          controller: txt,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          onChanged: (query) {
            performSearch(query);
          },
          decoration: InputDecoration(
            hintText: 'Search your notes...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
        )
            : Text(
          " Notes",
          style: GoogleFonts.titanOne(
            textStyle: TextStyle(fontSize: 26, color: Colors.black),
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25)),
            gradient: LinearGradient(
                colors: [Colors.white70, Colors.white],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter),
            border: Border.all(width: 1.5, color: Colors.black54),
          ),
        ),
        actions: [
          isSearching
              ? IconButton(
            onPressed: () {
              stopSearch();
            },
            icon: Icon(Icons.close),
          )
              : IconButton(
            onPressed: () {
              startSearch();
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('NotePad').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            notes = snapshot.data!.docs.map((doc) => doc.reference.id).toList();

            return Container(
              child: ListView.builder(
                itemCount: isSearching ? filteredNotes.length : notes.length,
                itemBuilder: (context, index) {
                  final note =
                  isSearching ? filteredNotes[index] : notes[index];
                  return Card(
                    child: ListTile(
                        title: Text(note),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoteView(title: note),
                            ),
                          );
                        },
                        trailing:
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              IconButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('NotePad')
                                      .doc(note)
                                      .delete();
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                ),
                              ),
                            ]
                        )

                    ),

                  );
                },
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
          showDialog(
            context: context,
            builder: (context) {
              return Container(
                child: AlertDialog(
                  title: TextField(
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w400),
                    controller: txt,
                    decoration: InputDecoration(
                        hintText: 'Enter your title'),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          if (txt.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(10),
                                    content: Text('Require a title')));
                            return;
                          }
                          String cleartext=txt.text;
                          txt.clear();
                          Navigator.of(context).pop();

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                CreateNote(
                                  title: cleartext,
                                ),
                          ),
                          );
                        },
                        child: Text('Create')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'))
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey)
        ),

        alignment: Alignment.topLeft,
        height: 500,
        width: 230,
        child: ListView(
          children: [
            Container(
              height: 150,
              width:50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(25) ,topRight: Radius.circular(25)),
                  border: Border.all(color: Colors.grey),
                  image: DecorationImage(fit: BoxFit.fill,
                      image: AssetImage('assets/drawer.png')
                  )
              ),

            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('CREATE YOUR NOTES',  style: GoogleFonts.titanOne(
                textStyle: TextStyle(fontSize: 23, color: Colors.grey),
              ),),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.account_circle_sharp,size: 22,),
                title: Text('ACCOUNT'),

              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.home,size: 22,),
                title: Text('HOME'),

              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.favorite,size: 22,),
                title: Text('FAVORITE'),

              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.settings,size: 22,),
                title: Text('SETTINGS'),
              ),
            ),
            TextButton(onPressed: ()async{
              await FirebaseAuth.instance.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
            },
                child:Text( 'SIGNOUT',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),))
          ],
        ),
      ),
    );
  }
}

