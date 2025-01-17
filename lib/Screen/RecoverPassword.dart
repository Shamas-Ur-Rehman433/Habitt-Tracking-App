import 'package:flutter/material.dart';
class RecoverPassword extends StatefulWidget {
  const RecoverPassword({super.key});

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {

  TextEditingController emil=new TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade900],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Icon(Icons.lock_reset_outlined,size: 300,color: Colors.blue.shade900,),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: emil,
                      decoration: InputDecoration(
                          prefixIcon:
                          Icon(Icons.email, color: Colors.blue.shade700),
                          hintText: 'Enter Email',
                          border: InputBorder.none,
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  

                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 15)),
                      child: Text(
                        'Send Link',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(height: 200,)

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
