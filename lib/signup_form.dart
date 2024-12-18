import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sociio/screens/profile_fill_form.dart';
import 'login.dart';
import 'navigation.dart';
import 'package:http/http.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  var emailText = TextEditingController();
  var passText = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool? isChecked = false;
  bool? isValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                    height: 200,
                    width: 350,
                    child: Image.asset('assets/Images/logo.png')),
              ),
              const Text(
                "Create Your Account",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white,
                    fontFamily: 'assets/fonts/OpenSans-Bold.ttf'),
              ),

              // Email
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(
                  width: 278,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailText,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!isBMUEmail(value)) {
                        return 'Email must end with @bmu.edu.in';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Your Email ID',
                      filled: true,
                      fillColor: const Color.fromRGBO(255, 255, 255, 0.3),
                      prefixIcon: const Icon(
                        Icons.mail,
                        color: Colors.redAccent,
                      ),
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
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 278,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: passText,
                      obscureText: true,
                      validator: (value){
                        if (value!.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        // You can add more complex validation criteria here
                        // For example, checking for the presence of special characters
                        // using a regular expression:
                        // if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                        //   return 'Password must contain special characters';
                        // }
                        return null; // Return null if the password is valid

                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Your Password',
                        filled: true,
                        fillColor: const Color.fromRGBO(255, 255, 255, 0.3),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.redAccent,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.remove_red_eye_outlined,
                          ),
                          onPressed: () {},
                        ),
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
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                      value: isChecked,
                      activeColor: Colors.lightBlueAccent,
                      onChanged: (newBool) {
                        setState(() {
                          isChecked = newBool;
                        });
                      }),
                  const Text(
                    'Remember Me',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        fontFamily: 'OpenSans'),
                  )
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: 250,
                  height: 49,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(39.32),
                      ),
                    ),
                    onPressed: () async {
                      String uEmail = emailText.text.toString();
                      String upass = passText.text;

                      print("Email: $uEmail, Password: $upass");
                      isValid=await checkIfEmailValid(uEmail);
                      if(isValid==false){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text( "Invalid Email, Please Enter a Valid Email")));
                      }

                      if (_formKey.currentState!.validate()) {
                        try{
                          FirebaseAuth auth=FirebaseAuth.instance;
                          FirebaseFirestore firestoreInstance=FirebaseFirestore.instance;
                          var response=await auth.createUserWithEmailAndPassword(email: uEmail, password: upass);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                 ProfileFillForm(email: emailText.text, isEditing: false)),
                          );
                        } on FirebaseAuthException catch (exc){
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(exc.toString())));
                          print("Error in sign up: ${exc}");

                        }
                        catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())));
                          print("Error in: ${e}");
                        }

                      }},
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 0.5,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0, left: 8.0),
                      child: Text(
                        'or',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'OpenSans',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 130,
                      height: 0.5,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: 278,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // <-- Radius
                      ),
                    ),
                    onPressed: ()async {
                      print("Continue with Google");
                      await signInWithGoogle();

                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileFillForm(email: x, isEditing: false)));


                    },
                    child: Row(
                      children: [
                        Image.asset('assets/Images/google 1.png'),
                        const Padding(
                          padding: EdgeInsets.only(left: 32.0),
                          child: Text(
                            'Continue with Google',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              fontFamily: 'OpenSans',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(top: 25.0),
              //       child: Image.asset('assets/Images/facebook 2.png'),
              //     ),
              //     Padding(
              //       padding:
              //           const EdgeInsets.only(top: 25.0, right: 20, left: 20),
              //       child: Image.asset('assets/Images/google 1.png'),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(top: 25.0),
              //       child: Image.asset('assets/Images/apple-logo 3.png'),
              //     ),
              //   ],
              // ),

              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          fontFamily: 'OpenSans',
                          color: Colors.white),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const Login()));
                      },
                      child: const Text(
                        ' Sign In',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            fontFamily: 'OpenSans'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  bool isBMUEmail(String email) {
    RegExp regex = RegExp(r"@[Bb][Mm][Uu]\.edu\.in$");
    return regex.hasMatch(email);
  }
  // Future<String> signInWithGoogle() async {
  //   final GoogleSignInAccount? gUser =await  GoogleSignIn().signIn();
  //   final GoogleSignInAuthentication gAuth=await gUser!.authentication;
  //   final credential=GoogleAuthProvider.credential(
  //     accessToken: gAuth.accessToken,
  //     idToken: gAuth.idToken,
  //   );
  //   print(credential);
  //   await FirebaseAuth.instance.signInWithCredential(credential);
  //   return gUser.email;
  //
  // }

  Future<bool> hasUserSignedInWithGoogle(String email) async {
    try {
      // Attempt to fetch sign-in methods for the email address
      final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      // Check if 'google.com' is present, indicating a Google sign-in
      return methods.contains('google.com');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        print('Invalid email format provided.');
      } else {
        print('Error checking sign-in methods: ${e.code}');
      }
      return false; // Handle error, assuming no Google sign-in
    }
  }

  Future<void> signInWithGoogle() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();

    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final email = googleUser.email!; // Access the email address

        // Check if user has already signed in with this Google account
        final hasPreviouslySignedUp = await hasUserSignedInWithGoogle(email);

        if (hasPreviouslySignedUp) {
          // User has already signed up with this Google account
          print('Welcome back, $email!');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User with this email already exists, considering log-in")));
        } else {
          // User is signing up for the first time with this Google account
          print('Welcome, $email!');
          // Handle new user logic (e.g., create user account in database)
          final GoogleSignInAuthentication gAuth=await googleUser!.authentication;
          final credential=GoogleAuthProvider.credential(
            accessToken: gAuth.accessToken,
            idToken: gAuth.idToken,
          );
          print(credential);
          await FirebaseAuth.instance.signInWithCredential(credential).then((value){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Google Sign Up Succesful, Fill Profile to Proceed")));

          });

          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileFillForm(email: googleUser.email, isEditing: false)));
        }

        // Proceed with sign-in using the Google credential (optional)
        // ...
      } else {
        print('Sign-in cancelled by user.');
      }
    } on FirebaseAuthException catch (e) {
      print('Error signing in with Google: ${e.code}');
    }
  }



  Future<bool> checkIfEmailValid(String email) async {
    const String baseUrl = 'https://api.proofy.io/verifyaddr';
    const String resultUrl="https://api.proofy.io/getresult";
    const String apiKey = 'OqB6ywiOuUWQMfNoR797'; // Replace with your actual API key (avoid hardcoding)
    const int appId = 61951; // Replace with your actual application ID (avoid hardcoding)
    int? cid;
    var url = Uri.parse('$baseUrl?aid=$appId&key=$apiKey&email=$email');
    bool works=false;
    try {
      final response = await get(url);
      final statusCode = response.statusCode;

      if (statusCode == 200) {
        final  Map<String,dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
        cid=data['cid'];

        if (data.containsKey('error')) {
          print('Error: ${data['message']}');
          return false; // Email validation failed due to API error
        }
        // else if (data.containsKey('checked') && data['checked']) {
        //   final result = data['result'] as List<dynamic>;
        //   if (result.isNotEmpty) {
        //     final emailStatus = result[0]['status'] as int;
        //     // Check for deliverable status (you can adjust the criteria based on your needs)
        //     return emailStatus == 1;
        //   } else {
        //     print('Email verification result unavailable');
        //     return false; // Inconclusive email validation
        //   }
        // }
        // else {
        //   print('Unexpected response format');
        //   return false; // Email validation failed due to unexpected response
        // }
      } else {
        print('Error: API request failed with status code $statusCode');
        return false; // Email validation failed due to network or API error
      }}catch(e){
      print(e);
    }
      url = Uri.parse('$resultUrl?aid=$appId&key=$apiKey&cid=$cid');
      try {
        final response = await get(url);
        final statusCode = response.statusCode;

        if (statusCode == 200) {
          final Map<String, dynamic> data2 = jsonDecode(response.body) as Map<String, dynamic>;
          final resultList = data2['result'] as List<dynamic>;
          if (resultList.isNotEmpty) {
            // Access the first element (assuming there's only one email)
            final emailData = resultList[0] as Map<String, dynamic>;

            // Extract and print the statusName
            final statusName = emailData['statusName'] as String;

            print(statusName); // Output: undeliverable
            if(statusName=="deliverable"){
              return true;
            }
          } else {
            print('No results found in the JSON object');
          }
        }

        } on Exception catch (e) {
      print('Error: $e');
    }
    return false; // Email validation failed due to a general error

  }


}
