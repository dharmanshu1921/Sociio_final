import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:sociio/cacheBuilder/signedInUser_cache.dart';
import 'package:sociio/cacheBuilder/userProvider.dart';
import 'package:sociio/models/user_model.dart';
import 'signup_form.dart';
import 'navigation.dart';
import 'package:sociio/models/user_model.dart' as UserModel;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var emailText = TextEditingController();
  var passText = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool? isChecked = false;

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
                  child: Image.asset('assets/Images/logo.png'),
                ),
              ),
              const Text(
                "Login to Your Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                  fontFamily: 'assets/fonts/OpenSans-Bold.ttf',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  width: 300,
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 300,
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
                          icon: const Icon(Icons.remove_red_eye_outlined),
                          onPressed: () {},
                        ),
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
                    },
                  ),
                  const Text(
                    'Remember Me',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      fontFamily: 'OpenSans',
                    ),
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
                      if (_formKey.currentState!.validate()) {
                        loginUser(context, uEmail, upass);
                      //  try{
                      //   FirebaseAuth auth=FirebaseAuth.instance;
                      //   FirebaseFirestore firestoreInstance=FirebaseFirestore.instance;
                      //   var response=await auth.signInWithEmailAndPassword(email: uEmail, password: upass);
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) =>
                      //         const Sociio()),
                      //   );
                      // } on FirebaseAuthException catch (exc){
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text(exc.toString())));
                      //   print("Error in sign in: ${exc}");
                      //
                      // }
                      // catch(e){
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(content: Text(e.toString())));
                      //   print("Error in: ${e}");
                      // }

                    }},
                    child: const Text(
                      'Sign In',
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
              TextButton(onPressed: (){}, child: Text("Forgot Password", style: TextStyle(color: Color(0xFFE65F73)),)),
              Row(
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
                    onPressed: () {
                      print("Continue with Google");
                      signInWithGoogle();
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
              //     // Padding(
              //     //   padding: const EdgeInsets.only(top: 25.0),
              //     //   child: Image.asset('assets/Images/facebook 2.png'),
              //     // ),
              //     Text("Continue with Google"),
              //     Padding(
              //       padding:
              //           const EdgeInsets.only(top: 25.0, right: 20, left: 20),
              //       child: Image.asset('assets/Images/google 1.png'),
              //     ),
              //     // Padding(
              //     //   padding: const EdgeInsets.only(top: 25.0),
              //     //   child: Image.asset('assets/Images/apple-logo 3.png'),
              //     // ),
              //   ],
              // ),

              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Do not have an account?',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        fontFamily: 'OpenSans',
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpForm()));
                      },
                      child: const Text(
                        ' Sign Up',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
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

  Future<void> loginUser(BuildContext context, String email, String password) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
      print("🔴🔴🔴🔴");

      var response = await auth.signInWithEmailAndPassword(email: email, password: password).then((value) async {
        var userDoc = await firestoreInstance.collection('users').where('uemail', isEqualTo: email).get();
        print("🔴🔴🔴🔴");

        print(userDoc);
        if (userDoc.docs.isNotEmpty) {
          var userData = userDoc.docs.first.data();
          print("USER DATA:\n${userData}\n\n");
          // Create a User object from the fetched data
          UserModel.User user = UserModel.User(
            uid: userData['uid'] ?? '',
            uname: userData['uname'] ?? '',
            uemail: userData['uemail'] ?? '',
            uphone: userData['uphone'] ?? '',
            ugender: userData['ugender'] ?? '',
            ubio: userData['ubio'] ?? '',
            uavatar: userData['uavatar'] ?? '',
          );
          // Update UserProvider with the signed-in user

          await storeSignedInUser(user).then((value) async{
            Provider.of<UserProvider>(context, listen: false).updateUser(user);

            // Update UserProvider with the signed-in user
          });
        } else {
          print("User not found in database");
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login Successful!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => Sociio()));

      });

      // Fetch user details from Firestore
    } catch (e) {
      // Handle errors appropriately (e.g., display an error message to the user)
      print("Error logging in: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Failed. Please check your credentials."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
          await FirebaseAuth.instance.signInWithCredential(credential).then((value) async{
            var userDoc = await FirebaseFirestore.instance.collection('users').where('uemail', isEqualTo: email).get();
            print("🔴🔴🔴🔴");

            print(userDoc);
            if (userDoc.docs.isNotEmpty) {
              var userData = userDoc.docs.first.data();
              print("USER DATA:\n${userData}\n\n");
              // Create a User object from the fetched data
              UserModel.User user = UserModel.User(
                uid: userData['uid'] ?? '',
                uname: userData['uname'] ?? '',
                uemail: userData['uemail'] ?? '',
                uphone: userData['uphone'] ?? '',
                ugender: userData['ugender'] ?? '',
                ubio: userData['ubio'] ?? '',
                uavatar: userData['uavatar'] ?? '',
              );
              // Update UserProvider with the signed-in user

              await storeSignedInUser(user).then((value) async{
                Provider.of<UserProvider>(context, listen: false).updateUser(user);

                // Update UserProvider with the signed-in user
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Login Successful!"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.push(context, MaterialPageRoute(builder: (context) => Sociio()));

            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("User not found in database", style: TextStyle(color: Colors.white),),
                  backgroundColor: Colors.red,

                ),
              );
            }
          });

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
}
