import 'package:flutter/material.dart';
import 'package:sellerapp/auth_screen.dart';
import 'package:sellerapp/widgets/global/global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sharedPreferences!.getString('name')!),
        centerTitle: true,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
              colors: [
                Colors.blue,
                Colors.blue,
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
            child: const Text('log out'),
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
            ),
            onPressed: () {
              firebaseAuth.signOut().then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (e) => const AuthScreen()));
              });
            }),
      ),
    );
  }
}
