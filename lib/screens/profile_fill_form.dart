

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:sociio/cacheBuilder/signedInUser_cache.dart';
import 'package:sociio/cacheBuilder/userProvider.dart';
import 'package:sociio/navigation.dart';

import '../Home.dart';
import '../models/user_model.dart';

class ProfileFillForm extends StatefulWidget {
  final String email;
  final bool isEditing;
  ProfileFillForm({required this.email, required this.isEditing});
  @override
  _ProfileFillFormState createState() => _ProfileFillFormState();
}

class _ProfileFillFormState extends State<ProfileFillForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _bioController = TextEditingController(text:"");
  File? image=null;
  String? _selectedGender;
  String _selectedCountry = 'Select Country';
  String _selectedCountryCode = '';
  String? imageUrl;

  User? user;
  @override

  void initState() {
    // TODO: implement initState

    super.initState();
    _emailController.text=widget.email;

  }
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context);
    user = userProvider.user;
    if(widget.isEditing==true){
      setState(() {
        _bioController=TextEditingController(text: user!.ubio);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fill Your Profile", style: TextStyle(color: Colors.white, fontSize: 17),),
        leading: IconButton(onPressed: (){
          if(widget.isEditing==true){
            Navigator.pop(context);
          }
        }, icon: Icon(Icons.arrow_back_rounded, color: Colors.white,),),
      ),
      body: SingleChildScrollView(
        child: Container(

          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: (){
                    _pickImage();
                  },
                  child: Stack(
                    children: [
                      widget.isEditing==true?
                  CircleAvatar(
                  radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: image == null ? NetworkImage(user!.uavatar) : FileImage(image!) as ImageProvider<Object>?,
                  )
                          :
                  CircleAvatar(
                  radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: image==null?AssetImage("assets/Images/no_image.jpg") as ImageProvider:FileImage(image!) as ImageProvider<Object>?,
                  ),


                       Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(50),
                                
                              ),
                              child:Icon(Icons.edit )))
                    ],
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    fillColor: const Color.fromRGBO(255, 255, 255, 0.3),
                    filled: true,
                    enabled: widget.isEditing==true?false:true,
                    hintText: widget.isEditing==true?user!.uname:'Username',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: const BorderSide(
                        color: Color(0xdcdcdcdc),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                TextFormField(
                  controller: _userIdController,
                  decoration: InputDecoration(
                    enabled: widget.isEditing==true?false:true,
                    hintText: widget.isEditing==true?user!.uid:'User ID',
                    filled: true,
                    fillColor: const Color.fromRGBO(255, 255, 255, 0.3),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(
                          color: Color(0xdcdcdcdc),
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(
                          color: Colors.redAccent,
                        )),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    enabled: widget.isEditing==true?false:true,
                    hintText: widget.isEditing==true?user!.uemail: 'Email',
                    fillColor: const Color.fromRGBO(255, 255, 255, 0.3),
                    filled: true,
                    enabledBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(13),
                      borderSide: const BorderSide(
                        color: Color(0xdcdcdcdc),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _bioController,

                  decoration: InputDecoration(
                    hintText:'Profile Bio',
                    fillColor: const Color.fromRGBO(255, 255, 255, 0.3),
                    filled: true,

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: const BorderSide(
                        color: Color(0xdcdcdcdc),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
          //   Container(
          //     padding: EdgeInsets.all(10),
          //     decoration: BoxDecoration(
          //       color: Color.fromRGBO(255, 255, 255, 0.3),
          //       border: Border.fromBorderSide(
          //           BorderSide(
          //         color: Color(0xdcdcdcdc),
          //       ),
          //       ),
          //       borderRadius: BorderRadius.circular(13)
          //
          //
          // ),
          //     child: Row(
          //       children: [
          //
          //         Expanded(
          //           child: InternationalPhoneNumberInput(
          //             onInputChanged: (PhoneNumber number) {
          //               _phoneNumberController.text=number.phoneNumber.toString();
          //               // Handle changes to the phone number (optional)
          //             },
          //             // selectorButtonAsPrefixIcon: true,
          //             hintText: 'Enter phone number',
          //             validator: (value) {
          //               if (value == null || value.isEmpty) {
          //                 return 'Please enter a phone number';
          //               }
          //               return null;
          //             },
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          //       SizedBox(height: 20),
                if(widget.isEditing==false)
                DropdownButtonFormField(
                  value: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      child: Text('Male'),
                      value: 'male',
                    ),
                    DropdownMenuItem(
                      child: Text('Female'),
                      value: 'female',
                    ),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Gender',
                    fillColor: const Color.fromRGBO(255, 255, 255, 0.3),
                    filled: true,
                    enabledBorder: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(13),
                      borderSide: const BorderSide(
                        color: Color(0xdcdcdcdc),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: ()async {
                    User? newUser;
                    var imageUrl;
                    if(widget.isEditing==true){

                      if(image!=null && _bioController.text!="Nothing"){
                        imageUrl= await uploadImages(image!);
                         newUser=User(uid: user!.uid, uname: user!.uname, uemail: user!.uemail, uphone: user!.uphone, ugender: user!.ugender, ubio: _bioController.text, uavatar:imageUrl);
                        updateUserAvatar(imageUrl);
                      }
                      else if(image!=null && _bioController.text=="Nothing"){
                        imageUrl= await uploadImages(image!);
                        newUser=User(uid: user!.uid, uname: user!.uname, uemail: user!.uemail, uphone: user!.uphone, ugender: user!.ugender, ubio: user!.ubio, uavatar:imageUrl);
                        updateUserAvatar(imageUrl);

                      }
                      else{
                        updateUserBio(_bioController.text);
                         newUser=User(uid: user!.uid, uname: user!.uname, uemail: user!.uemail, uphone: user!.uphone, ugender: user!.ugender, ubio: _bioController.text, uavatar:user!.uavatar);


                      }
                      await storeSignedInUser(newUser, update: true).then((value) async{
                        Provider.of<UserProvider>(context, listen: false).updateUser(newUser!);

                        // Update UserProvider with the signed-in user

                      });
                      Navigator.pop(context);

                    } else{
                      createUser();
                    }
                    // Continue button pressed
                  },
                  child: Text(widget.isEditing?'Save':'Continue', style: TextStyle(color: Colors.white, fontSize: 16),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> uploadImages(File image) async {
    final storage = FirebaseStorage.instance;
    final imageUrls = <String>[];

    final reference = storage.ref().child('users_avatars/${image.path.split('/').last}');
    final uploadTask = reference.putFile(File(image.path));
    final snapshot = await uploadTask.whenComplete(() => null);
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      for (var pickedFile in result.paths) {
        // Add the picked image to the images list for preview and upload
        setState(() {
          image= (File(pickedFile!));
        });
      }
    }
    print("Picked Images are:\n");
  }

  Future<void> createUser() async{
    final firestore = FirebaseFirestore.instance;
    final postsCollection = firestore.collection('users'); // Replace 'posts' with your collection name

    final timestamp = FieldValue.serverTimestamp(); // Server-side timestamp

    try {
      String url = await uploadImages(image!);

      // Create a User object using the uploaded image URL and other form data
      final user = User(
        uid: _userIdController.text,
        uname: _usernameController.text,
        uemail: _emailController.text,
        uphone: _phoneNumberController.text,
        ugender: _selectedGender!,
        ubio: _bioController.text,
        uavatar: url,
      );

      // Store user data in the local cache (shared preferences)

      // Add user data to Firestore (assuming you have a postsCollection reference)
      await postsCollection.add(user.toMap()).then((value) async {
        await storeSignedInUser(user).then((value) async{
          Provider.of<UserProvider>(context, listen: false).updateUser(user);

          // Update UserProvider with the signed-in user
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("User Added Successfully!", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.black,
          ),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => Sociio()));
      });
    } catch (e) {
      // Handle errors appropriately (e.g., display an error message to the user)
      print("Error adding user: $e");
    }
  }
  Future<void> updateUserBio(String newBio) async {
    final userSnapshots = FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: user!.uid);



    final querySnapshot = await userSnapshots.get();
    print(querySnapshot.docs);
    if (querySnapshot.docs.isNotEmpty) {

      final documentRef = querySnapshot.docs.first.reference;
      print(documentRef);
      final updatedData = {'ubio': newBio};
      await documentRef.update(updatedData).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text( "Updated Bio Successfully!!"))));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text( "Couldn't save the changes...")));
      // Handle the case where no document is found (optional)

    }
  }
  Future<void> updateUserAvatar(String newImageUrl) async {
    final userSnapshots = FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: user!.uid);

    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>+${user!.uid}");

    final querySnapshot = await userSnapshots.get();
    if (querySnapshot.docs.isNotEmpty) {
      final documentRef = querySnapshot.docs.first.reference;
      final updatedData = {'uavatar': newImageUrl};
      await documentRef.update(updatedData).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text( "Updated Profile Photo Successfully!!"))));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text( "Couldn't save the changes...")));
      // Handle the case where no document is found (optional)
    }
  }



}



