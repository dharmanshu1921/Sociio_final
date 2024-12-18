import 'package:flutter/material.dart';

class Func extends StatelessWidget {
  const Func({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, 
        children: <Widget>[
          ElevatedButton.icon(
            onPressed: () {
              print('First button pressed');
            },
            icon: Icon(Icons.directions_bus, color: Colors.red), 
            label: Text('Shuttle Booking', style: TextStyle(color: Colors.white)),
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(16.0)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.red;
                  }
                  return Colors.transparent;
                },
              ),
              side: MaterialStateProperty.resolveWith<BorderSide>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return BorderSide(color: Colors.red); 
                  }
                  return BorderSide(color: Colors.transparent); 
                },
              ),
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton.icon(
            onPressed: () {
              print('Second button pressed');
            },
            icon: Icon(Icons.lock, color: Colors.red), 
            label: Text('Gate Pass', style: TextStyle(color: Colors.white)), 
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(16.0)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), 
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.red; 
                  }
                  return Colors.transparent; 
                },
              ),
              side: MaterialStateProperty.resolveWith<BorderSide>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return BorderSide(color: Colors.red); 
                  }
                  return BorderSide(color: Colors.transparent); 
                },
              ),
            ),
          ),
          SizedBox(height: 20.0), 
          ElevatedButton.icon(
            onPressed: () {
              print('Third button pressed');
            },
            icon: Icon(Icons.phone, color: Colors.red), 
            label: Text('Helpline Numbers', style: TextStyle(color: Colors.white)), 
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(16.0)), 
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.red; 
                  }
                  return const Color.fromARGB(0, 64, 44, 44); 
                },
              ),
              side: MaterialStateProperty.resolveWith<BorderSide>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return BorderSide(color: Colors.red); 
                  }
                  return BorderSide(color: Colors.transparent); 
                },
              ),
            ),
          ),
          SizedBox(height: 20.0),
          ElevatedButton.icon(
            onPressed: () {
              print('Fourth button pressed');
            },
            icon: Icon(Icons.food_bank, color: Colors.red), 
            label: Text('Mess Menu', style: TextStyle(color: Colors.white)), 
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(16.0)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), 
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.red; 
                  }
                  return Colors.transparent; 
                },
              ),
              side: MaterialStateProperty.resolveWith<BorderSide>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return BorderSide(color: Colors.red); 
                  }
                  return BorderSide(color: Colors.transparent); 
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
