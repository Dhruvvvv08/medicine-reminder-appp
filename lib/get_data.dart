import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GetData {
  int userId;
  int id;
  String title;
  String body;

  GetData({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory GetData.fromJson(Map<String, dynamic> json) => GetData(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    body: json["body"],
  );
}

class Getdata extends StatefulWidget {
  const Getdata({super.key});

  @override
  State<Getdata> createState() => _GetdataState();
}

class _GetdataState extends State<Getdata> {
  List<GetData>? getdatamodel;

  // Simplified API call method
  Future<void> getdata() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );

    if (response.statusCode == 200) {
      // Directly decode the response and map it to GetData list
      setState(() {
        getdatamodel =
            (jsonDecode(response.body) as List)
                .map((data) => GetData.fromJson(data))
                .toList();
        print(getdatamodel?[0].id);
      });
    } else {
      print("Something went wrong");
    }
  }

  @override
  void initState() {
    super.initState();
    getdata(); // Fetch data when widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Posts")),
      body:
          getdatamodel == null
              ? Center(
                child: CircularProgressIndicator(),
              ) // Show loading indicator
              : ListView.builder(
                itemCount: getdatamodel!.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(getdatamodel![i].title),
                    subtitle: Text(getdatamodel![i].body),
                  );
                },
              ),
    );
  }
}
