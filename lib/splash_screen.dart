import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sellerapp/auth_screen.dart';
import 'package:sellerapp/home_screen.dart';
import 'package:sellerapp/widgets/global/global.dart';
//import 'package:foodsellerapp/authentication/auth_screen.dart';
//import 'package:foodsellerapp/authentication/register_screen.dart';
//import 'package:foodsellerapp/authentication/auth_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {

   
    Timer(const Duration(seconds: 2), () async {
       if (firebaseAuth.currentUser != null ){
       Navigator.push(
          context, MaterialPageRoute(builder: (c) => const HomeScreen()));
    }
    else
    {       
          Navigator.push(
          context, MaterialPageRoute(builder: (c) => const AuthScreen()));
    }
      
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            //  Image.network('https://images.ctfassets.net/hrltx12pl8hq/3MbF54EhWUhsXunc5Keueb/60774fbbff86e6bf6776f1e17a8016b4/04-nature_721703848.jpg?fit=fill&w=480&h=270'),
               //
               //
              Image.asset('assets/images/seller.png',width: 100.0, height: 100.0),
             //Image.asset("https://images.ctfassets.net/hrltx12pl8hq/3MbF54EhWUhsXunc5Keueb/60774fbbff86e6bf6776f1e17a8016b4/04-nature_721703848.jpg?fit=fill&w=480&h=270"),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "Sell Food Online",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 40,
                      fontFamily: "Signature",
                      letterSpacing: 3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
