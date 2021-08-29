import 'package:flutter/material.dart';
class CentralPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final logoRECAT = Image.asset('imagens/Recat_logo.png',
      height: 250,
      width: 250,

    );
    final NameRECAT = Material(
      child:  Text("RECAT",
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 30.0,color: Color(0xff009E74), fontWeight: FontWeight.bold)
      ),
    );
    final DescriptionRECAT = Material(
      child:  Text("",
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 15.0,color: Color(0xff16613D), fontStyle: FontStyle.italic)
      ),

    );
    final emailField = TextField(
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "senha",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
    );
    final loginButon = Material(

      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFF009E74),
      child: MaterialButton(

        minWidth: 200.0,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {},
        child: Text("Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20.0,color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final createButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFF009E74),
      child: MaterialButton(
        minWidth: 200.0,
        //minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CentralPage()),
          );},
        child: Text("Criar Conta",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20.0,color: Colors.white, fontWeight: FontWeight.bold)
        ),
      ),
    );
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                logoRECAT,
                SizedBox(height: 25.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButon,
                SizedBox(
                  height: 15.0,
                ),
                createButon,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

