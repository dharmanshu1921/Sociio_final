import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:sociio/get_started.dart';
import 'package:sociio/lets_you_in.dart';
import 'package:sociio/login.dart';
import 'package:sociio/onboarding/widgets/slider_indicator.dart';
import 'package:sociio/signup_form.dart';

class OnboardingScreenView extends StatefulWidget {
  const OnboardingScreenView({super.key});

  @override
  State<OnboardingScreenView> createState() => _OnboardingScreenViewState();
}

class _OnboardingScreenViewState extends State<OnboardingScreenView> {
  @override
  int index=0;
  List<String> images=["intropng1.png","intropng2.png","intropng3.png"];
  List<String> onbrdingMainStr=["Explore What's\nTrending","Enjoy with your\nPeers","Make Connects with\nSociio"];
  List<String> onbrdingSubStr=["In your Campus","Find activities around Campus","With Peers in Campus"];

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,

        ),

        onPressed: (){
          setState(() {
            if(index!=2){
              index=index+1;
            }
            else{
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpForm()));
            }
            print(images[index]);
          });
        },
        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(100),
          side: BorderSide(
            color: Color(0xFF181A1C)
          ),

        ),
        backgroundColor: Color(0xFF252525),
        
        

      ),
      body: Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        color: Color(0xFF181A1C),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Align(
            //   alignment: Alignment.topRight,
            //   child: TextButton(
            //     child: Text("Skip", style: TextStyle(color:Color(0xff202244) , fontWeight: FontWeight.bold, fontSize: 15 ),),
            //     onPressed: (){
            //       Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginViewScreen()));
            //
            //     },
            //   ),
            // ),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SizedBox(height: 30,),
                SizedBox(
                  height: 300, // Set a fixed height for the image
                  child: Image.asset(
                    "assets/Images/${images[index]}",
                    fit: BoxFit.contain, // Scale the image to fit within the bounds
                  )
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  
                    children: [
                      Text(
                        onbrdingMainStr[index],
                        style: TextStyle(color:Colors.white, fontSize: 30, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 10,),
                      Text(onbrdingSubStr[index], style: TextStyle(color: Colors.white, fontSize: 20),),
                    ],
                  ),
                ),
              ],
            ),




            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: 100,
                child:SliderIndicator(currentIndex: index, itemCount: 3, )
              ),
            )
          ],
        ),
      ),
    );
  }
}
