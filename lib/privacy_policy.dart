import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy and Security", style: TextStyle(color: Colors.white, fontSize: 17),),
        leading: IconButton(onPressed: (){
            Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_rounded, color: Colors.white,),),
      ),
      body: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Text(
              'Privacy Policy',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Effective date: May 1, 2024',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Sociio ("us", "we", or "our") operates the Sociio mobile application (the "Service").',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'This page informs you of our policies regarding the collection, use, and disclosure of personal data when you use our Service and the choices you have associated with that data.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Information Collection and Use',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We collect several different types of information for various purposes to provide and improve our Service to you.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Types of Data Collected',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Personal Data: While using our Service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you ("Personal Data"). Personally identifiable information may include, but is not limited to:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '- Email address',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '- First name and last name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '- Phone number',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            // Add more Text widgets for different sections of your privacy policy
            // Use the same approach to style them
          ],
        ),

    );
  }
}
