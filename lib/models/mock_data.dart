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
  // new TodoObject.import("SOME_RANDOM_UUID", "Custom", 1, ColorChoies.colors[0], Icons.alarm, [new TaskObject("Task", new DateTime.now()),new TaskObject("Task2", new DateTime.now()),new TaskObject.import("Task3", new DateTime.now(), true)]),
  new TodoObject.import("SOME_RANDOM_UUID", "Custom", 1, ColorChoies.colors[1], Icons.alarm, {
    new DateTime(2018, 5, 3): [
      new TaskObject("Meet Clients", new DateTime(2018, 5, 3)),
      new TaskObject("Design Sprint", new DateTime(2018, 5, 3)),
      new TaskObject("Icon Set Design for Mobile", new DateTime(2018, 5, 3)),
      new TaskObject("HTML/CSS Study", new DateTime(2018, 5, 3)),
    ],
    new DateTime(2018, 5, 4): [
      new TaskObject("Meet Clients", new DateTime(2018, 5, 4)),
      new TaskObject("Design Sprint", new DateTime(2018, 5, 4)),
      new TaskObject("Icon Set Design for Mobile", new DateTime(2018, 5, 4)),
      new TaskObject("HTML/CSS Study", new DateTime(2018, 5, 4)),
    ]
  }),
  new TodoObject("Personal", Icons.person),
  new TodoObject("Work", Icons.work),
  new TodoObject("Home", Icons.home),
  new TodoObject("Shopping", Icons.shopping_basket),
  new TodoObject("School", Icons.school),
];

