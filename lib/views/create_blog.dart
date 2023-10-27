

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:storyblogger/services/crud.dart';
import 'package:image_picker/image_picker.dart';
class CreateBlog extends StatefulWidget {
  const CreateBlog({Key? key}) : super(key: key);

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {

 File  ? selectedImage ;
final picker = ImagePicker();
bool isLoading = false;



  TextEditingController titleTextEditingController = new TextEditingController();
  TextEditingController descTextEditingController = new TextEditingController();
  TextEditingController authorTextEditingController = new TextEditingController();

 CrudMethods crudMethods = new CrudMethods();
Future getImage() async {
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  setState(() {
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  });
}

Future<void> uploadBlog() async {
  if (selectedImage != null) {
    // upload the image

    setState(() {
      isLoading = true;
    });
    Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child("blogImages")
        .child("${randomAlphaNumeric(9)}.jpg");

    final UploadTask task = firebaseStorageRef.putFile(selectedImage!);

    var imageUrl;
    await task.whenComplete(() async {
      try {
        imageUrl = await firebaseStorageRef.getDownloadURL();
      } catch (onError) {

          print("Error");

      }

      print(imageUrl);
    });

    // print(downloadUrl);

    Map<String, dynamic> blogData = {
      "imgUrl": imageUrl,
      "author": authorTextEditingController.text,
      "title": titleTextEditingController.text,
      "desc": descTextEditingController.text
    };

    crudMethods.addData(blogData).then((value) {
      setState(() {
        isLoading = true;
      });
      Navigator.pop(context);
    });

    // upload the blog info
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
   appBar: AppBar(
     title: Text("Share Your Story"),
     actions: [
       GestureDetector(
         onTap: (){
           uploadBlog();
         },
         child: Padding(
           padding: EdgeInsets.symmetric(horizontal: 16),
           child: Icon(Icons.file_upload),
         ),
       )
     ],
   ),
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),)
      :
      SingleChildScrollView(
        child: Container(
          margin : EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [ GestureDetector(
              onTap: (){
                getImage();
              },
              child: selectedImage !=null ? Container(
                height: 150,
                margin: EdgeInsets.symmetric(vertical: 24),
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: Image.file(selectedImage!,
                  fit: BoxFit.cover,
                  ),
                ),
              )
                  : Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
                margin: EdgeInsets.symmetric(vertical: 24),
                width: MediaQuery.of(context).size.width,
                child:  Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
              children : <Widget>[
          TextField(
            controller: titleTextEditingController,
            decoration: InputDecoration(hintText: "Enter title"),
          ),
          TextField(
            controller: descTextEditingController,
            decoration: InputDecoration(hintText: "Enter desc"),
          ),
          TextField(
            controller:authorTextEditingController,
            decoration:InputDecoration(hintText: "Enter author name"),
          ),
            ]
          )
          )
        ],),),
      ),
    );
  }
}
