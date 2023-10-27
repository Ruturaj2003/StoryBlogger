import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:storyblogger/services/crud.dart';
import 'package:storyblogger/views/create_blog.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = new CrudMethods();

    QuerySnapshot ?  blogSnapshot;


  @override
  void initState() {
    crudMethods.getData().then((result) {
      blogSnapshot = result;
      setState(() {});
    });
    super.initState();
  }

  Widget blogsList() {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 24),
        itemCount: blogSnapshot!.docs.length,
        itemBuilder: (context, index) {
          return BlogTile(
            author: blogSnapshot!.docs[index].get('author'),
            title: blogSnapshot!.docs[index].get('title'),
            desc: blogSnapshot!.docs[index].get('desc'),
            imgUrl: blogSnapshot!.docs[index].get('imgUrl'),
          );
        },
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
            Text("Read",
              style: TextStyle(fontSize: 22),
            ),
            Text("Ex",
              style: TextStyle(fontSize: 22,color: Colors.blue),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateBlog()));
              },
               child: Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}


class BlogTile extends StatelessWidget {
  final String imgUrl, title, desc, author;
  BlogTile(
      { required this.author,
        required this.desc,
        required this.imgUrl,
        required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24, right: 16, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Image.network(
                imgUrl,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(height: 2),
          Text(
            '$desc - By $author',
            style: TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }
}