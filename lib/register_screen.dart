//import 'dart:ffi';
import 'dart:io';
//import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:foodsellerapp/widget/custom_Text_Field.dart';
//import 'package:foodsellerapp/widget/error_dialog.dart';
///import 'package:foodsellerapp/widget/loading_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
//  import 'package:image_picker/image_picker.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
//import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'package:sellerapp/home_screen.dart';
//import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:sellerapp/widgets/custom_text_field.dart';
import 'package:sellerapp/widgets/error_dialog.dart';
import 'package:sellerapp/widgets/global/global.dart';
import 'package:sellerapp/widgets/loading_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  XFile? imageXFile;
  XFile? imageXFile2;
  File? path;
  final ImagePicker? _picker = ImagePicker();
  String sellerImageUrl = '';
  String completeAddress = '';
  XFile? _image;
  String? _uploadedFileURL;

  Position? position;
  List<Placemark>? placeMarks;

  Future<Position> getCurrentLocation() async {
    /// Determine the current position of the device.
    ///
    /// When the location services are not enabled or permissions
    /// are denied the `Future` will return an error.
//Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position newPosition = await Geolocator.getCurrentPosition();
    if (kDebugMode) {
      print(newPosition);
    }
    position = newPosition;
    placeMarks =
        await placemarkFromCoordinates(position!.longitude, position!.latitude);
    Placemark pMark = placeMarks![0];
    String completeAddress =
        '${pMark.subThoroughfare},${pMark.thoroughfare},${pMark.subLocality} ${pMark.subAdministrativeArea},${pMark.administrativeArea},${pMark.postalCode},${pMark.country}';
    locationController.text = completeAddress;
    // ignore: avoid_print
    print(completeAddress);
    setState(() {
      completeAddress = completeAddress;
    });

    // }
    return newPosition;
    //await Geolocator.getCurrentPosition();

    // Position newPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // position = newPosition;
    // placeMarks =
    //     await placemarkFromCoordinates(position!.longitude, position!.latitude);
    // Placemark pMark = placeMarks![0];
    // String completeAddress =
    //     '${pMark.subThoroughfare},${pMark.thoroughfare},${pMark.subLocality} ${pMark.subAdministrativeArea},${pMark.administrativeArea},${pMark.postalCode},${pMark.country}';
    // locationController.text = completeAddress;
    // // ignore: avoid_print
    // print(completeAddress);
  }

  // }

  ////get image
  Future chooseFile() async {
    imageXFile = await _picker?.pickImage(source: ImageSource.gallery);
    //.then((image) {
    final xpath = imageXFile?.path() ?? "assets/images/seller.png";
    final filepath = File(xpath);
    setState(() {
      //_image = image;
      path = filepath;
    });
    //});
  }

  ///
  ///
  ///
  ///

  Future _getImage() async {
    imageXFile = await _picker?.pickImage(source: ImageSource.gallery);
    final xpath = imageXFile!.path;
    final filepath = File(imageXFile!.path());
    final ddd = await File(
            "https://images.ctfassets.net/hrltx12pl8hq/3MbF54EhWUhsXunc5Keueb/60774fbbff86e6bf6776f1e17a8016b4/04-nature_721703848.jpg?fit=fill&w=480&h=270")
        .create();
    // ignore: avoid_print

    setState(() {
      path = filepath;
      imageXFile;
      //     sellerImageUrl = 'images/seller.png';
    });
    // ignore: avoid_print
    print(path);
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      // showDialog(
      //     context: context,
      //     builder: (c) {
      //       return const ErrorDialog(message: "Please pick an image");
      //     });
    } //else {
    if (passwordController.text == confirmPasswordController.text) {
      if (nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          locationController.text.isNotEmpty) {
        showDialog(
            context: context,
            builder: (c) {
              return const LoadingDialog(message: "Account is being registrd ");
            });
        String fileName = DateTime.now().microsecondsSinceEpoch.toString();
        fstorage.Reference reference = fstorage.FirebaseStorage.instance
            .ref()
            .child("sellers")
            .child(fileName);
        fstorage.UploadTask uploadTask = reference.putFile(path!);
        fstorage.TaskSnapshot taskSnapshot =
            await uploadTask.whenComplete(() => {});
        await taskSnapshot.ref.getDownloadURL().then((url) => {
              sellerImageUrl = url,
              // ignore: avoid_print
              print(sellerImageUrl),
              authenticateSellerAndSignUp(),
            });
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return const ErrorDialog(
                  message: "Please complete required Fileds");
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(message: "password do not match");
          });
    }
    //}
  }

  //////signUp to firebase

  void authenticateSellerAndSignUp() async {
    User? currentUser;
    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((auth) => {currentUser = auth.user})
        .catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: error.message.toString());
          });
    });

    if (currentUser != null) {
      await saveDataToFireStore(currentUser!);
      // .then((value) => {
      Navigator.pop(context);
      Route newRoute = MaterialPageRoute(builder: (c) => const HomeScreen());
      Navigator.pushReplacement(context, newRoute);
      // }
      // );
    }
  }

  Future saveDataToFireStore(User? currentUser) async {
    FirebaseFirestore.instance.collection('sellers').doc(currentUser?.uid).set({
      'sellerId': currentUser?.uid,
      'sellerEmail': emailController.text.trim(),
      'sellerName': nameController.text.trim(),
      'sellerAvatarUrl': sellerImageUrl,
      'phone': phoneController.text.trim(),
      'addrress': completeAddress,
      'status': "approved",
      'earning': 0.0,
      'let': position?.latitude,
      'lng': position?.longitude,
    });

    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser!.uid);
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("email", emailController.text.trim());
    await sharedPreferences!.setString("photoUrl", sellerImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                // _getImage();
                chooseFile();
              },
              // mouseCursor: Mo,
              child: //kIsWeb
                  //     // ? Image.network('images/seller.png')
                  //  imageXFile != null? Image(image:FileImage(File('https://static5.depositphotos.com/1007168/472/i/950/depositphotos_4725473-stock-photo-hot-summer-sun-wearing-shades.jpg') )):
                  //  Image.asset('images/seller.png'),
                  //:
                  CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: imageXFile == null
                    ? null // FileImage(File('https://i.imgur.com/pV9OeCY.png'))
                    : //null, //
                    // FileImage(path!),
                    FileImage(path!),
                radius: MediaQuery.of(context).size.width * 0.10,
                child: imageXFile == null
                    ? Icon(
                        Icons.add_a_photo_outlined,
                        size: MediaQuery.of(context).size.width * 0.10,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: nameController,
                    hintText: "Name",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    data: Icons.email,
                    controller: emailController,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: passwordController,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    isObsecure: true,
                  ),
                  CustomTextField(
                    data: Icons.phone,
                    controller: phoneController,
                    hintText: "Phone",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    data: Icons.my_location,
                    controller: locationController,
                    hintText: "Cafe/Resturant Location",
                    isObsecure: false,
                    enabled: true,
                  ),
                  Container(
                    width: 400,
                    height: 40,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      label: const Text(
                        'Get My Current Location',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        getCurrentLocation();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  formValidation();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyan,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
