import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<Posts> fetchPost() async {
  final response =
      await http.get('https://questions-itera-nau.herokuapp.com/questions/1051/answers');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return Posts.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Posts {
  final List<Post> posts;

  Posts({
    this.posts,
    });

    factory Posts.fromJson(List<dynamic> parsedJson) {

    List<Post> posts = new List<Post>();
    posts = parsedJson.map((i) =>Post.fromJson(i)).toList();

    return new Posts(
      posts: posts
    );
  }

}

class Post {
  final int id;
  final String text;

  Post({this.id, this.text});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      text: json['text'],
    );
  }
}

void main() => runApp(MyApp(posts: fetchPost()));

class MyApp extends StatelessWidget {
  final Future<Posts> posts;

  MyApp({Key key, this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Posts>(
            future: posts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                  return new ListView.builder(
                      itemCount: snapshot.data.posts.length,
                      itemBuilder: (BuildContext ctxt, int index) {


            
              return ListTile(
                title: Text(snapshot.data.posts[index].id.toString()),
                subtitle: Text(snapshot.data.posts[index].text),
              );




                      });
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}