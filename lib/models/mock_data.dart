import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';

class ColorChoies {
  static const List<Color> colors = [
    const Color(0xFF5A89E6),
    const Color(0xFFF77B67),
    const Color(0xFF4EC5AC),
  ];
}

List<TodoObject> todos = [
  //  TodoObject.import("SOME_RANDOM_UUID", "Custom", 1, ColorChoies.colors[0], Icons.alarm, [new TaskObject("Task",  DateTime.now()),new TaskObject("Task2",  DateTime.now()),new TaskObject.import("Task3",  DateTime.now(), true)]),
   TodoObject.import("SOME_RANDOM_UUID", "Custom", 1, ColorChoies.colors[1], Icons.alarm, {
     DateTime(2018, 5, 3): [
       TaskObject("Meet Clients",  DateTime(2018, 5, 3)),
       TaskObject("Design Sprint",  DateTime(2018, 5, 3)),
       TaskObject("Icon Set Design for Mobile",  DateTime(2018, 5, 3)),
       TaskObject("HTML/CSS Study",  DateTime(2018, 5, 3)),
    ],
     DateTime(2018, 5, 4): [
       TaskObject("Meet Clients",  DateTime(2018, 5, 4)),
       TaskObject("Design Sprint",  DateTime(2018, 5, 4)),
       TaskObject("Icon Set Design for Mobile",  DateTime(2018, 5, 4)),
       TaskObject("HTML/CSS Study",  DateTime(2018, 5, 4)),
    ]
  }),
   TodoObject("Personal", Icons.person),
   TodoObject("Work", Icons.work),
   TodoObject("Home", Icons.home),
   TodoObject("Shopping", Icons.shopping_basket),
   TodoObject("School", Icons.school),
];

