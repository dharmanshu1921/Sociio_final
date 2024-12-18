
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sociio/Home.dart';
import 'package:sociio/cacheBuilder/likedpost_cache.dart';
import 'package:sociio/cacheBuilder/userProvider.dart';
import 'package:sociio/models/user_model.dart' as UserModel;
import 'package:sociio/navigation.dart';
import 'cacheBuilder/signedInUser_cache.dart';
import 'get_started.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          storageBucket: "gs://sociio-7b374.appspot.com",
          apiKey:"AIzaSyA6GIW6RTQXXRyTqIIsYVJBIQaK5CTmm1E" ,
          appId: "1:1083862658551:android:22f603582a9161ca9ad2f2",
          messagingSenderId:"1083862658551" ,
          projectId: "sociio-7b374"
      )
  );
  UserModel.User? user = await getSignedInUser();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request notification permissions
  NotificationSettings settings = await messaging.requestPermission();

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission for notifications');

    // Get the FCM token for the device

    // Send this token to your server for future use (e.g., store in database for targeted notifications)
  } else {
    print('User declined or has not granted permission for notifications');
  }
  String? token = await messaging.getToken();
  print('Device token: $token');
  if (token != null) {
    await saveTokenToDatabase(token);
  }


  runApp(

    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider(user:user)), // Add LikeState provider
        ChangeNotifierProvider(create: (_) => LikeState()),
        // Add other providers if needed
      ],
      child: MyApp(),
    ),
    //   ChangeNotifierProvider<UserProvider>(
    //   create: (_) => UserProvider(user: user),
    //   child: MyApp(),
    // ),

  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}
class MyApp extends StatelessWidget {
  final User? user;
  const MyApp({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'Sociio'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    replaceWith(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 320,
              width: 400,
              margin: const EdgeInsets.only(top: 70),
              child: Image.asset('assets/Images/logo.png'),
            ),
            const Text(
              "an initiative by",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 10,
                color: Colors.white,
                fontFamily: 'assets/fonts/OpenSans-Bold.ttf',
              ),
            ),
            SizedBox(
              height: 50,
              width: 150,
              child: Center(child: Image.asset('assets/Images/bmu_logo.png')),
            ),
            const SizedBox(height: 30),
            const SizedBox(
              height: 300,
              width: 500,
              child: Center(
                child: SpinKitWave(color: Colors.red, size: 50.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void replaceWith(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      print("Cached User: $user");
      if (user == null) {
        // Access user data using user.uid, user.uname, etc.
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const GetStarted()));
      } else {
        // Handle no user scenario
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const Sociio()));
      }
    });
  }
}

Future<void> saveTokenToDatabase(String token) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final userDoc = FirebaseFirestore.instance.collection('userTokens').doc(user.uid);

    await userDoc.set({
      'token': token,
      'createdAt': FieldValue.serverTimestamp(), // optional
       // optional
    });
  }
}
