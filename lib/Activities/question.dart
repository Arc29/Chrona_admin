import 'dart:collection';
import 'dart:collection' as prefix0;


import 'package:chrona_1/Activities/article.dart';


import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Question_Route extends StatefulWidget {
  @override
  _Question_RouteState createState() => _Question_RouteState();
}

class _Question_RouteState extends State<Question_Route> {
  int selectedIndex = 0;
  DatabaseReference databaseReference;
  FirebaseDatabase firebaseDatabase;
  Query query;
  @override
  void initState() {
    firebaseDatabase = FirebaseDatabase.instance;
    databaseReference = firebaseDatabase.reference().child("Question");
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController t1,t2;
    return Scaffold(
        appBar: AppBar(
          title: new Text("Audit Questions"),
          actions: <Widget>[
            
          ],
          backgroundColor: Colors.black,
        ),
        body: new Column(
          children: <Widget>[
            new Flexible(
              child: new FirebaseAnimatedList(
                  query: databaseReference.orderByChild("verify").equalTo(false),
                  padding: new EdgeInsets.all(8.0),
                  reverse: false,
                  itemBuilder: (_, DataSnapshot snapshot,
                      Animation<double> animation, int x) {
                      TextEditingController t1=TextEditingController();
                    
                   TextEditingController t2=TextEditingController();
                   t1.text=snapshot.value['question'];t2.text=(snapshot.value['tags'] is String)?snapshot.value['tags']:snapshot.value['tags'].join(";");
                    // tags.text=snapshot.value["tags"];
                    //print(snapshot.value);
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
                              autocorrect: true,
                              autofocus: false,
                              // initialValue: snapshot.value["question"],
                              maxLength: 256,
                              controller: t1,
                              maxLines: null,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  labelText: "Question",
                                  hintText: 'Enter Question ',
                                  prefixIcon: Icon(Icons.question_answer),
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
                              autocorrect: true,
                              autofocus: false,
                              // initialValue: snapshot.value["tags"].join(';'),
                              controller: t2,
                              maxLength: 256,
                              maxLines: null,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  labelText: "Tags",
                                  hintText: 'Enter Tags ',
                                  prefixIcon: Icon(Icons.grade),
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
                                  onPressed: () => Verify(t1.text,t2.text,snapshot.key),
                                  child: Text("Verify"),
                                ),
                                Padding(padding: EdgeInsets.only(left: 20.0)),
                                RaisedButton(
                                  onPressed: () => Delete(snapshot.key),
                                  child: Text("Delete"),
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

  void _ontappeditem(int value) {
    
    if (value == 1) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Article()));
    }
    
  }
Delete(String key){
    databaseReference.child(key).remove();
  }
  

  Verify(String qtxt,ttxt,String key) {
    
      databaseReference.child(key).child("question").set(qtxt);
      databaseReference.child(key).child("tags").set(ttxt.split(';'));
      databaseReference.child(key).child("verify").set(true);
  }

  
}
