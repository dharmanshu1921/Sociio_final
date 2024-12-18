import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sociio/Home.dart';
import 'package:sociio/cacheBuilder/userProvider.dart';
import 'package:sociio/chats/services/notification_service.dart';
import 'package:sociio/models/user_model.dart' as UserModel;
import 'package:sociio/navigation.dart';



class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  List<String> categories = ['Achievements', 'Events']; //recent removed for the time being, recent logic to be implemented on homepage
  String selectedCategory = 'Achievements';
  List<File> images = [];
  List<String> urls=[];
  TextEditingController descriptionController = TextEditingController();
  TextEditingController hashtagsController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  UserModel.User? user;

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
        title: const Text('Create Post'),
        
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      resizeToAvoidBottomInset: false, 
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text('Select Image(s)'),
              const SizedBox(height: 16.0),
              Center(
                child: SizedBox(
                  width: 400, 
                  child: SizedBox(
                    width:100,
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return IconButton(
                            onPressed: _pickImages,
                            icon: const Icon(Icons.add),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Stack(
                            children: [
                              Image.file(
                                images[index - 1] as File,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      images.removeAt(index - 1);
                                    });
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              Visibility(
                  visible:selectedCategory=="Achievements"?false:true ,
                  child: const SizedBox(height: 16.0)),
              Visibility(
                visible:selectedCategory=="Achievements"?false:true ,
                child: TextField(
                  controller: titleController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Add title',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: descriptionController,
                maxLines: null, 
                keyboardType: TextInputType.multiline, 
                decoration: const InputDecoration(
                  hintText: 'Add description',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red), 
                ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: hashtagsController,
                decoration: const InputDecoration(
                  hintText: 'Add hashtags',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red), 
                ),
                ),
              ),
              const SizedBox(height: 16.0),
              Visibility(
                visible: selectedCategory=="Achievements"?false:true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _selectDate,
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,color: Colors.red, ),
                          const SizedBox(width: 8.0),
                          Text(selectedDate == null
                              ? 'Select Date'
                              : selectedDate!.toString().split(' ')[0],
                               style: const TextStyle(color: Colors.white),
                              ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _selectTime,
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.red, ),
                          const SizedBox(width: 8.0),
                          Text(selectedTime == null
                              ? 'Select Time'
                              : selectedTime!.format(context),
                               style: const TextStyle(color: Colors.white),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: createPost,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    ),
                  child: const Text('Upload',style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      for (var pickedFile in result.paths) {
        // Add the picked image to the images list for preview and upload
        setState(() {
          images.add(File(pickedFile!));
        });
        await uploadImages(images);
      }
    }
    print("Picked Images are:\n");
  }



  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        print(selectedDate);

      });
    }
  }

  Future<void> _selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        print(selectedTime);
      });
    }
  }

  void _uploadPost() {
    String description = descriptionController.text;
    String hashtags = hashtagsController.text;

    print('Category: $selectedCategory');
    print('Description: $description');
    print('Hashtags: $hashtags');
    if (selectedDate != null) {
      print('Selected Date: $selectedDate');
    }
    if (selectedTime != null) {
      print('Selected Time: $selectedTime');
    }
    if (images.isNotEmpty) {
      print('Images:');
      for (var image in images) {
        print(image.path);
      }
    }

    _resetFields();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post uploaded successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _resetFields() {
    setState(() {
      descriptionController.clear();
      hashtagsController.clear();
      selectedDate = null;
      selectedTime = null;
      images.clear();
    });
  }

  Future<List<String>> uploadImages(List<File> images) async {
    final storage = FirebaseStorage.instance;
    final imageUrls = <String>[];

    for (final image in images) {
      final reference = storage.ref().child('post_images/test/${image.path.split('/').last}');
      final uploadTask = reference.putFile(File(image.path));
      final snapshot = await uploadTask.whenComplete(() => null);
      final url = await snapshot.ref.getDownloadURL();
      imageUrls.add(url);
    }

    return imageUrls;
  }

  Future<void> createPost() async{
    final firestore = FirebaseFirestore.instance;
    final postsCollection = firestore.collection('posts'); // Replace 'posts' with your collection name

    final timestamp = FieldValue.serverTimestamp(); // Server-side timestamp

    try{
    urls=await uploadImages(images);

    final post = {
      'title': selectedCategory=="Achievements"?"Achievement of ${user!.uid}": titleController.text,
        'date': selectedCategory=="Achievements"?(DateFormat('dd/MM/yyyy').format(DateTime.now()).toString()):(DateFormat('dd/MM/yyyy').format(selectedDate!).toString()),
        'description': descriptionController.text,
        'hashtags': hashtagsController.text,
        'images': urls,
        'posted_by': user?.uid,
        'posted_on': timestamp,
        'time':  selectedCategory=="Achievements"? ("${TimeOfDay.now().hour}:${TimeOfDay.now().minute}"): ("${selectedTime?.hour}:${selectedTime?.minute}"),
      "type": selectedCategory=="Achievements"? "achievement":"event",
      "likes":0,
      "comments":[],
    };

      await postsCollection.add(post).then((value){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Posted Uploaded Successfully!", style: TextStyle(color: Colors.white),), backgroundColor: Colors.black, ));
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Sociio()));
      });
    }
  catch(e){
    print("Error occured: \n${e}" );
  }
    Future<void> saveTokenToDatabase(String token) async {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDoc = FirebaseFirestore.instance.collection('userTokens').doc(user.uid);

        await userDoc.set({
          'token': token,
          'createdAt': FieldValue.serverTimestamp(), // optional
          'platform': Platform.operatingSystem // optional
        });
      }
    }
// sendNotification("New Event", "hello");

  }


// Future<void> uploadImageToFirebase(PickedFile pickedFile) async {
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   final imageUrls = <String>[];
  //
  //   try {
  //
  //     final imageRef = storage.ref().child('images/test/${pickedFile.path}'); // Create a reference
  //     final uploadTask = imageRef.putFile(File(pickedFile.path)); // Upload the file
  //     final snapshot = await uploadTask.whenComplete(() => null); // Wait for completion
  //     final downloadUrl = await snapshot.ref.getDownloadURL(); // Get the download URL
  //
  //     // setState(() {
  //     //   images.add(File(pickedFile.path) as PickedFile); // Add the local file path for preview
  //     // });
  //
  //     // You can now use the downloadUrl (e.g., display the image or store it)
  //     print('Image uploaded successfully! Download URL: $downloadUrl');
  //   } on FirebaseException catch (e) {
  //     // Handle errors appropriately (e.g., show a snackbar)
  //     print('Error uploading image: ${e.code} - ${e.message}');
  //   }
  // }


}

