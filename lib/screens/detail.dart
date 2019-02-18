import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/CustomCheckboxTile.dart';
import 'package:todo/models/todo.dart';

class DetailPage extends StatefulWidget {

  DetailPage({@required this.todoObject, Key key}) : super(key: key);

  final TodoObject todoObject;

  @override
  _DetailPageState createState() =>  _DetailPageState();

}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin{

  double percentComplete;
  AnimationController animationBar;
  double barPercent = 0.0;
  Tween<double> animT;
  AnimationController scaleAnimation;

  @override
  void initState() {
    scaleAnimation =  AnimationController(vsync: this, duration: const Duration(milliseconds: 1000), lowerBound: 0.0, upperBound: 1.0);

    percentComplete = widget.todoObject.percentComplete();
    barPercent = percentComplete;
    animationBar =  AnimationController(vsync: this, duration: const Duration(milliseconds: 100))..addListener(() {
      setState(() {
        barPercent = animT.lerp(animationBar.value);
      });
    });;
    animT =  Tween<double>(begin: percentComplete, end: percentComplete);
    scaleAnimation.forward();
    super.initState();
  }

  void updateBarPercent() async {
    double newPercentComplete = widget.todoObject.percentComplete();
    if (animationBar.status == AnimationStatus.forward || animationBar.status == AnimationStatus.completed) {
      animT.begin = newPercentComplete;
      await animationBar.reverse();
    }else if (animationBar.status == AnimationStatus.reverse || animationBar.status == AnimationStatus.dismissed) {
      animT.end = newPercentComplete;
      await animationBar.forward();
    }else {
      print("wtf");
    }
    percentComplete = newPercentComplete;
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: <Widget>[
         Hero(
          tag: widget.todoObject.uuid + "_background",
          child:  Container(
            decoration:  BoxDecoration(
              color: Colors.white,
              borderRadius:  BorderRadius.circular(0.0),
            ),
          ),
        ),
         Scaffold(
          backgroundColor: Colors.transparent,
          appBar:  AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading:  IconButton(
              icon:  Icon(Icons.arrow_back, color: Colors.grey,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[
               Hero(
                tag: widget.todoObject.uuid + "_more_vert",
                child:  Material(
                  color: Colors.transparent,
                  type: MaterialType.transparency,
                  child:  IconButton(
                    icon:  Icon(Icons.more_vert, color: Colors.grey,),
                    onPressed: () {},
                  ),
                ),
              )
            ],
          ),
          body:  Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 35.0),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                 Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child:  Align(
                    alignment: Alignment.bottomLeft,
                    child:  Hero(
                      tag: widget.todoObject.uuid + "_icon",
                      child:  Container(
                        decoration:  BoxDecoration(
                          shape: BoxShape.circle,
                          border:  Border.all(color: Colors.grey.withAlpha(70), style: BorderStyle.solid, width: 1.0),
                        ),
                        child:  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:  Icon(widget.todoObject.icon, color: widget.todoObject.color,),
                        ),
                      ),
                    ),
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child:  Align(
                    alignment: Alignment.bottomLeft,
                    child:  Hero(
                      tag: widget.todoObject.uuid + "_number_of_tasks",
                      child:  Material(
                        color: Colors.transparent,
                        child:  Text(
                          widget.todoObject.taskAmount().toString() + " Tasks",
                          style:  TextStyle(

                          ),
                        )
                      ),
                    )
                  )
                ),
                 Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child:  Align(
                    alignment: Alignment.bottomLeft,
                    child:  Hero(
                      tag: widget.todoObject.uuid + "_title",
                      child:  Material(
                        color: Colors.transparent,
                        child:  Text(
                          widget.todoObject.title,
                          style:  TextStyle(
                            fontSize: 30.0
                          ),
                        ),
                      ),
                    )
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.only(bottom:30.0),
                  child:  Align(
                    alignment: Alignment.bottomLeft,
                    child:  Hero(
                      tag: widget.todoObject.uuid + "_progress_bar",
                      child:  Material(
                        color: Colors.transparent,
                        child:  Row(
                          children: <Widget>[
                             Expanded(
                              child:  LinearProgressIndicator(
                                value: barPercent,
                                backgroundColor: Colors.grey.withAlpha(50),
                                valueColor:  AlwaysStoppedAnimation<Color>(widget.todoObject.color),
                              ),
                            ),
                             Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child:  Text(
                                (barPercent*100).round().toString() + "%"
                              ),
                            )
                          ],
                        ),
                      )
                    )
                  ),
                ),
                 Expanded(
                  child:  ScaleTransition(
                    scale: scaleAnimation,
                    child:  ListView.builder(
                      padding: const EdgeInsets.all(0.0),
                      itemBuilder: (BuildContext context, int index) {
                        DateTime currentDate = widget.todoObject.tasks.keys.toList()[index];
                        DateTime _now =  DateTime.now();
                        DateTime today =  DateTime(_now.year, _now.month, _now.day);
                        String dateString;
                        if (currentDate.isBefore(today)) {
                          dateString = "Previous - " +  DateFormat.E().format(currentDate);
                        }else if (currentDate.isAtSameMomentAs(today)) {
                          dateString = "Today";
                        }else if (currentDate.isAtSameMomentAs(today.add(const Duration(days: 1)))) {
                          dateString = "Tomorrow";
                        }else {
                          dateString =  DateFormat.E().format(currentDate);
                        }
                        List<Widget> tasks = [new Text(dateString)];
                        widget.todoObject.tasks[currentDate].forEach((task) {
                          tasks.add(new CustomCheckboxListTile(
                            activeColor: widget.todoObject.color,
                            value: task.isCompleted(),
                            onChanged: (value) {
                              setState(() {
                                task.setComplete(value);
                                updateBarPercent();
                              });
                            },
                            title:  Text(task.task),
                            secondary:  Icon(Icons.alarm),
                          ));
                        });
                        return  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: tasks,
                        );
                      },
                      itemCount: widget.todoObject.tasks.length,
                    ),
                  )
                )
              ],
            ),
          ),
        )
      ],
    );
  }

}
