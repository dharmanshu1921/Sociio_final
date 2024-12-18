import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'chats/chat.dart';
import 'func.dart';

class Sociio extends StatefulWidget {
  const Sociio({Key? key}) : super(key: key);

  @override
  State<Sociio> createState() => _SociioState();
}

class _SociioState extends State<Sociio> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 8.0),
        child: ClipRRect(

          borderRadius: BorderRadius.circular(30),
          child: Container(
            height: 60,

            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: GNav(
              
              backgroundColor: Colors.transparent,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.black,
              gap: 10,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20), 
              tabs: const [
                GButton(
                  icon: Icons.home_rounded,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.chat,
                  text: 'Chat',
                ),
                GButton(
                  icon: Icons.extension,
                  text: 'Func',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    ChatPage(),
    const Func(),
  ];
}
