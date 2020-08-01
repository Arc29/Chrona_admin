
import 'package:chrona_1/Activities/question.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';




class Article extends StatefulWidget {
  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  int selectedIndex = 1;
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference databaseReferenceArticle;

  @override
  void setState(VoidCallback fn) {}
  static bool OnChanged;
  @override
  void initState() {
    OnChanged = false;
    super.initState();
    databaseReferenceArticle = firebaseDatabase.reference().child("Article");
  }
  
  

  @override
  Widget build(BuildContext context) {
    TextEditingController t1,t2;
    return Scaffold(
        appBar: AppBar(
          title: new Text("Audit Articles"),
          actions: <Widget>[
            
          ],
          backgroundColor: Colors.black,
        ),
        body: new Column(
          children: <Widget>[
            new Flexible(
              child: new FirebaseAnimatedList(
                  query: databaseReferenceArticle
                      .orderByChild("verify")
                      .equalTo(false),
                  padding: new EdgeInsets.all(8.0),
                  reverse: false,
                  itemBuilder: (_, DataSnapshot snapshot,
                      Animation<double> animation, int x) {
                        TextEditingController t1=TextEditingController();
                    
                   TextEditingController t2=TextEditingController();
                    
                        t1.text=snapshot.value['header'];t2.text=snapshot.value['body'];

                    
                    print(t1.text+" "+t2.text);
                    
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.20,
                      child: new Card(
                        elevation: 5.0,
                        child: Column(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.all(5.0)),
                            TextFormField(
                              readOnly: false,
                              // initialValue: snapshot.value['header'].toString(),
                              
                              autocorrect: true,
                              autofocus: false,
                              controller: t1,
                              maxLength: 128,
                              maxLines: null,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  labelText: "Heading",
                                  hintText: 'Enter Heading ',
                                  prefixIcon: Icon(Icons.view_headline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  )),
                            ),
                            Text(
                              "Questioner is ${snapshot.value["username"]}",
                              textAlign: TextAlign.left,
                            ),
                            Padding(padding: EdgeInsets.all(4.0)),
                            TextFormField(
                              readOnly: false,
                              // initialValue: snapshot.value['body'].toString(),
                              
                              autocorrect: true,
                              autofocus: false,
                              controller: t2,
                              maxLength: 1024,
                              maxLines: null,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  labelText: "Body",
                                  hintText: 'Enter Body ',
                                  prefixIcon: Icon(Icons.description),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  )),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.check),
                                Text(
                                  " " + snapshot.value["likes"].toString(),
                                  style: TextStyle(color: Colors.indigo),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsetsDirectional.only(start: 5.0)),
                                Icon(Icons.clear),
                                Text(
                                  " " + snapshot.value["dislikes"].toString(),
                                  style: TextStyle(color: Colors.red),
                                ),
                                Padding(padding: EdgeInsets.only(left: 50.0)),

                                RaisedButton(

                                  child: Text("Delete"),
                                  onPressed:()=> Delete(snapshot.key),
                                ),
                                Padding(padding: EdgeInsets.only(left: 30.0)),

                                RaisedButton(

                                  child: Text("Verify"),
                                  onPressed:()=> Update(t1.text,t2.text,snapshot.key),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      
                    );
                  }),
            )
          ],
        ),
        
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
           
            BottomNavigationBarItem(
                icon: Icon(Icons.question_answer),
                title: new Text("Q/A"),
                ),
            BottomNavigationBarItem(
                icon: Icon(Icons.description), title: new Text("Article")),
           
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.red,
          onTap: _ontappeditem,
        ));
  }

  

Update(String htxt,String btxt,String key) {

    
      debugPrint(htxt+" "+btxt+" Update");
      databaseReferenceArticle.child(key).child("header").set(htxt);
      databaseReferenceArticle.child(key).child("body").set(btxt);
      databaseReferenceArticle.child(key).child("verify").set(true);
    
  }

  Delete(String key){
    debugPrint("Delete");
    databaseReferenceArticle.child(key).remove();
  }

  void _ontappeditem(int value) {
    
    if (value == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Question_Route()));
    }
    
  }

  
}
