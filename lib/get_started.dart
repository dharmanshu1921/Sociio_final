import 'package:flutter/material.dart';
import 'package:sociio/onboarding/onboarding_view.dart';

import 'lets_you_in.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: SizedBox(
                  height: 300,
                  width: 350,
                  child: Image.asset('assets/Images/getstarted.png')),
            ),
            const SizedBox(height: 120,),
            const Padding(
              padding:  EdgeInsets.only(bottom: 6.0),
              child: Text("Welcome to SOCIIO", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Colors.white,
                  fontFamily: 'assets/fonts/OpenSans-Bold.ttf'
              ),),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: Text("CONNECT . SHARE . SOCIIO", style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'OpenSans'
              ),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Container(
                height: 30,
                // width: 10,
              ),
            ),
            SizedBox(
              width: 278,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(39.32), 
                  ),
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const OnboardingScreenView()));

                },
                child: const Text('Get Started'),
              ),
            ),
          ],
        )

    );
  }


}
