import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Cities {
  final String name;

  Cities({
    required this.name,
  });
  Cities.fromMap(Map<String, dynamic?> result) : name = result["name"];
  Map<String, dynamic?> toMap() {
    return {
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Cities{name: $name}';
  }
}
