import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey=GlobalKey<FormState>();
  TextEditingController txt1=TextEditingController();
  TextEditingController txt2=TextEditingController();
  bool text=true;
  void handleSignup()async{
    String Email=txt1.text;
    String Password=txt2.text;
    print(('Email:$Email'));
    print('Password:$Password');
    try{
      print('SignUp');
      final credential=await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: Email,
        password: Password,);
      print('in SignUp success');
      print('Credential=${credential.additionalUserInfo}');
    }catch(e){
      print(' SignUp Error=$e');
    }
  }
  void handleSignin()async{
    String Email=txt1.text;
    String Password=txt2.text;
    print(('Email:$Email'));
    print('Password:$Password');
    try{
      print('SignIn');
      final credential=await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: Email,
        password: Password,);
      print('in SignIn success');
      print('Credential=${credential.additionalUserInfo}');
    }catch(e){
      print(' SignIn Error=$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                width:250,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(250),
                    image: DecorationImage(fit: BoxFit.cover,
                        image: AssetImage('assets/drawer.png')),
                    border: Border.all(width: 1.0,color: Colors.grey)
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 35,left: 10),
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1,color: Colors.deepPurple)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 40.0,bottom: 5),
                child: TextFormField(
                  controller: txt1,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your Email',
                      hintStyle: TextStyle(color: Colors.grey)
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 25,left:10,),
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1,color: Colors.deepPurple)

              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 40.0,bottom: 5),
                child: TextFormField(
                  controller: txt2,
                  obscureText: text,
                  obscuringCharacter: '.',
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: GestureDetector(
                        onTap: (){
                          setState(() {
                            text=!text;
                          });
                        },
                        child: Icon(Icons.visibility),

                      )
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 200),
              child: TextButton(
                  onPressed: (){},
                  child: Text('forgot password',style: TextStyle(color: Colors.blue),)
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 10,top: 10,bottom: 10),

              child: SizedBox(
                height: 30,
                width: 100,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.withOpacity(0.6),
                    ),
                    onPressed: (){
                      if(txt1.text.isEmpty&&txt2.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(15),
                            content: Text('fill all the requirements')));
                      }else {
                        handleSignup();
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                      }

                    },
                    child: Text('SIGNUP',style: TextStyle(color: Colors.white),)),
              ),
            ),
            Text('Already have an account?',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),),
            Container(
              margin: EdgeInsets.only(left: 10,top: 10),

              child: SizedBox(
                height: 30,
                width: 100,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.withOpacity(0.6),
                    ),
                    onPressed: (){
                      handleSignin();

                    },
                    child: Text('SIGNIN',style: TextStyle(color: Colors.white),)),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text('-or-'),
            SizedBox(
              height: 6,
            ),
            Container(
                width: 300,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 0.7,color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        image: DecorationImage(fit: BoxFit.fill,
                          image: AssetImage('assets/gogo.jpg'),
                        ),
                        color: Colors.white,

                      ),
                    ),
                    TextButton(onPressed: (){},
                        child: Text('SIGNUP WITH GOOGLE ACCONT',style: TextStyle(fontWeight: FontWeight.bold),))
                  ],
                )
            )

          ],
        ),
      ),
    );
  }
}
