import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sociio/cacheBuilder/userProvider.dart';
import 'models/user_model.dart';
import 'recent.dart';
import 'settings.dart'; 
import 'notification.dart'; 
import 'search_post.dart'; 
import 'create_post.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  User? user;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context);
    user = userProvider.user;
    print(user);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 18.0), 
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  );
                },
                child: Padding(
                  padding:  EdgeInsets.only(right: 8.0),
                  child:  CircleAvatar(
                    backgroundImage: NetworkImage(user==null?"https://t4.ftcdn.net/jpg/03/40/12/49/360_F_340124934_bz3pQTLrdFpH92ekknuaTHy8JuXgG7fi.jpg" :user!.uavatar),
                  ),
                ),
              ),
              Text('Hello👋, '
                  '${user==null?"User":user!.uname}', style:TextStyle(fontSize: 19)
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0, right: 0.0),
            child: IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(145.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14.0, right: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SearchPostPage()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12.0), 
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.search),
                              SizedBox(width: 12.0),
                              Text('Search posts...'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreatePostScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0), 
                        ),
                        backgroundColor: Colors.red, 
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                        child: Row(
                          children: const [
                            Icon(Icons.add, color: Colors.white), 
                            SizedBox(width: 3.0),
                            Text('Create Post', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              tabTop(context),

            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Recent(showType: "all",),
          Recent(showType: "achievement"),
          Recent(showType: "event"),
        ],
      ),
    );
  }

  Widget tabTop(BuildContext context) {
    return TabBar(
      // isScrollable: true,
      controller: _tabController,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      indicator: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        color: Colors.red,
      ),
      tabs: const [
        Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text('Recent', style: TextStyle(fontSize: 12),),
          ),
        ),
        Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text('Achievements', style: TextStyle(fontSize: 12),),
          ),
        ),
        Tab(
          child: Align(
            alignment: Alignment.center,
            child: Text('Events', style: TextStyle(fontSize: 12),),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
