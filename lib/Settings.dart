import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sociio/cacheBuilder/message_cache.dart';
import 'package:sociio/cacheBuilder/signedInUser_cache.dart';
import 'package:sociio/cacheBuilder/userProvider.dart';
import 'package:sociio/models/user_model.dart';
import 'package:sociio/notification.dart';
import 'package:sociio/privacy_policy.dart';
import 'package:sociio/savedPosts.dart';
import 'package:sociio/screens/profile_fill_form.dart';
import 'login.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _logoutClicked = false;
  User? user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context);
    user = userProvider.user;
    print("User: ${user}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A1C),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: Image.asset(
                'assets/Images/setbg.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundImage: NetworkImage(user==null?"https://t4.ftcdn.net/jpg/03/40/12/49/360_F_340124934_bz3pQTLrdFpH92ekknuaTHy8JuXgG7fi.jpg":user!.uavatar),
                        ),
                        SizedBox(height: 20),
                        Text(
                          '${user==null?"Test Username":user!.uname}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${user==null?"Test UserID":user!.uid}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                            '${user==null?"Test User Bio":user!.ubio}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Divider(
                      color: Colors.white,
                      thickness: 1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 18.0),
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildButton(context, Icons.edit, 'Update Profile', ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileFillForm(email: user!.uemail, isEditing: true,),))),
                  // const SizedBox(height: 15),
                  // buildButton(context, Icons.edit, 'Change Status'),
                  const SizedBox(height: 15),
                  buildButton(context, Icons.bookmark, 'Saved Posts',()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SavedPostPage(),))),
                  const SizedBox(height: 15),
                  buildButton(context, Icons.security, 'Privacy & Security',()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SecurityPage(),))),
                  const SizedBox(height: 15),
                  buildButton(context, Icons.notifications, 'Notifications & Sounds',()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationPage(),))),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    child: ElevatedButton(
                      onPressed: _logoutClicked
                          ? null
                          : () async{
                              setState(() {
                                _logoutClicked = true;
                              });
                              await clearSignedInUser().then((value) async{
                                await ChatCacheService().clearCacheMessages().then((value) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => Login()),
                                        (route) => false,
                                  );
                                });

                              });

                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _logoutClicked ? Colors.red : const Color(0xFFF05D5E).withOpacity(0.60),
                        padding: const EdgeInsets.all(15),
                      ),
                      child: const Text(
                        'Log out',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(BuildContext context, IconData icon, String label, void Function() callback) {
    return GestureDetector(
      onTap: (){
        callback();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
