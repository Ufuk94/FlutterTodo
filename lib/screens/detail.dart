import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/CustomCheckboxTile.dart';
import 'package:todo/models/todo.dart';

class DetailPage extends StatefulWidget {

  DetailPage({@required this.todoObject, Key key}) : super(key: key);

  final TodoObject todoObject;

  @override
  _DetailPageState createState() => new _DetailPageState();

}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin{

  double percentComplete;
  AnimationController animationBar;
  double barPercent = 0.0;
  Tween<double> animT;
  AnimationController scaleAnimation;

  @override
  void initState() {
    scaleAnimation = new AnimationController(vsync: this, duration: const Duration(milliseconds: 1000), lowerBound: 0.0, upperBound: 1.0);

    percentComplete = widget.todoObject.percentComplete();
    barPercent = percentComplete;
    animationBar = new AnimationController(vsync: this, duration: const Duration(milliseconds: 100))..addListener(() {
      setState(() {
        barPercent = animT.lerp(animationBar.value);
      });
    });;
    animT = new Tween<double>(begin: percentComplete, end: percentComplete);
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
    return new Stack(
      children: <Widget>[
        new Hero(
          tag: widget.todoObject.uuid + "_background",
          child: new Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.circular(0.0),
            ),
          ),
        ),
        new Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.grey,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[
              new Hero(
                tag: widget.todoObject.uuid + "_more_vert",
                child: new Material(
                  color: Colors.transparent,
                  type: MaterialType.transparency,
                  child: new IconButton(
                    icon: new Icon(Icons.more_vert, color: Colors.grey,),
                    onPressed: () {},
                  ),
                ),
              )
            ],
          ),
          body: new Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 35.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: new Align(
                    alignment: Alignment.bottomLeft,
                    child: new Hero(
                      tag: widget.todoObject.uuid + "_icon",
                      child: new Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: new Border.all(color: Colors.grey.withAlpha(70), style: BorderStyle.solid, width: 1.0),
                        ),
                        child: new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Icon(widget.todoObject.icon, color: widget.todoObject.color,),
                        ),
                      ),
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: new Align(
                    alignment: Alignment.bottomLeft,
                    child: new Hero(
                      tag: widget.todoObject.uuid + "_number_of_tasks",
                      child: new Material(
                        color: Colors.transparent,
                        child: new Text(
                          widget.todoObject.taskAmount().toString() + " Tasks",
                          style: new TextStyle(

                          ),
                        )
                      ),
                    )
                  )
                ),
                new Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: new Align(
                    alignment: Alignment.bottomLeft,
                    child: new Hero(
                      tag: widget.todoObject.uuid + "_title",
                      child: new Material(
                        color: Colors.transparent,
                        child: new Text(
                          widget.todoObject.title,
                          style: new TextStyle(
                            fontSize: 30.0
                          ),
                        ),
                      ),
                    )
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(bottom:30.0),
                  child: new Align(
                    alignment: Alignment.bottomLeft,
                    child: new Hero(
                      tag: widget.todoObject.uuid + "_progress_bar",
                      child: new Material(
                        color: Colors.transparent,
                        child: new Row(
                          children: <Widget>[
                            new Expanded(
                              child: new LinearProgressIndicator(
                                value: barPercent,
                                backgroundColor: Colors.grey.withAlpha(50),
                                valueColor: new AlwaysStoppedAnimation<Color>(widget.todoObject.color),
                              ),
                            ),
                            new Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: new Text(
                                (barPercent*100).round().toString() + "%"
                              ),
                            )
                          ],
                        ),
                      )
                    )
                  ),
                ),
                new Expanded(
                  child: new ScaleTransition(
                    scale: scaleAnimation,
                    child: new ListView.builder(
                      padding: const EdgeInsets.all(0.0),
                      itemBuilder: (BuildContext context, int index) {
                        DateTime currentDate = widget.todoObject.tasks.keys.toList()[index];
                        DateTime _now = new DateTime.now();
                        DateTime today = new DateTime(_now.year, _now.month, _now.day);
                        String dateString;
                        if (currentDate.isBefore(today)) {
                          dateString = "Previous - " + new DateFormat.E().format(currentDate);
                        }else if (currentDate.isAtSameMomentAs(today)) {
                          dateString = "Today";
                        }else if (currentDate.isAtSameMomentAs(today.add(const Duration(days: 1)))) {
                          dateString = "Tomorrow";
                        }else {
                          dateString = new DateFormat.E().format(currentDate);
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
                            title: new Text(task.task),
                            secondary: new Icon(Icons.alarm),
                          ));
                        });
                        return new Column(
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
