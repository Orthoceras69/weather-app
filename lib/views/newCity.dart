import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../db/notes_database.dart';

void queryNotes() async {
  var cities = await CityDatabase.instance.readAllNotes();
  print(cities);
}


class City extends StatelessWidget {
  const City({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("new City adding"),
      ),
      body: Center(
          child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'nom ? ',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'lat ? ',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'long ? ',
            ),
          ),
          ElevatedButton(onPressed: queryNotes, child: Text("Add City")),
        ],
      )),
    );
  }
}
