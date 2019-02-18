import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo/CustomIcons.dart';
import 'package:todo/animation/custom_scroll_physics.dart';
import 'package:todo/models/mock_data.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/screens/detail.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  ScrollController scrollController;
  Color backgroundColor;
  Tween<Color> colorTween;
  int currentPage = 0;
  Color constBackColor;

  @override
  void initState() {
    colorTween =  ColorTween(begin: ColorChoies.colors[0], end: ColorChoies.colors[1]);
    backgroundColor = todos[0].color;
    scrollController =  ScrollController();
    scrollController.addListener(() {
      ScrollPosition position = scrollController.position;
      ScrollDirection direction = position.userScrollDirection;
      int page = (position.pixels / (position.maxScrollExtent/(todos.length.toDouble()-1))).toInt();
      double pageDo = (position.pixels / (position.maxScrollExtent/(todos.length.toDouble()-1)));
      double percent = pageDo - page;
//      print("int page: " + page.toString());
//      print("double page: " + pageDo.toString());
//      print("percent " + percent.toString());
      if (direction == ScrollDirection.reverse) {
        //page begin 
        if (todos.length-1 < page+1) {
          return;
        }
        colorTween.begin = todos[page].color;
        colorTween.end = todos[page+1].color;
        setState(() {
          backgroundColor = colorTween.lerp(percent);
        });
      }else if (direction == ScrollDirection.forward) {
        //+1 begin page end
        if (todos.length-1 < page+1) {
          return;
        }
        colorTween.begin = todos[page].color;
        colorTween.end = todos[page+1].color;
        setState(() {
          backgroundColor = colorTween.lerp(percent);
        });
      }else {
        return;
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    final double _width = MediaQuery.of(context).size.width;
    final double _ratioW =_width/375.0;

    final double _height = MediaQuery.of(context).size.height;
    final double _ratioH = _height/812.0;

    

    return  Container(
      decoration:  BoxDecoration(
        color: backgroundColor
      ),
      child:  Scaffold(
        backgroundColor: Colors.transparent,
        appBar:  AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title:  Text("TODO"),
          leading:  IconButton(
            icon:  Icon(CustomIcons.menu),
            onPressed: () {},
          ),
          actions: <Widget>[
             IconButton(
              icon:  Icon(CustomIcons.search, size: 26.0,),
              onPressed: () {},
            )
          ],
        ),
        body:  Container(
          child:  Stack(
          children: <Widget>[
             Container(
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                   Container(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 50.0, right: 60.0),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                         Padding(
                          padding: const EdgeInsets.only(bottom: 25.0),
                          child:  Container(
                            decoration:  BoxDecoration(
                              boxShadow: [
                                 BoxShadow(
                                  color: Colors.black38,
                                  offset:  Offset(5.0, 5.0),
                                  blurRadius: 15.0
                                )
                              ],
                              shape: BoxShape.circle,
                            ),
                            child:  CircleAvatar(
                              backgroundColor: Colors.grey,
                            ),
                          ),
                        ),
                         Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child:  Text(
                            "Hello, John.",
                            style:  TextStyle(
                              color: Colors.white,
                              fontSize: 30.0
                            ),
                          ),
                        ),
                         Text(
                          "This is a daily quote.",
                          style:  TextStyle(
                            color: Colors.white70
                          ),
                        ),
                         Text(
                          "You have 10 tasks to do today.",
                          style:  TextStyle(
                            color: Colors.white70
                          ),
                        ),
                      ],
                    ),
                  ),
                   Container(
                    height: 350.0,
                    width: _width,
                    child:  ListView.builder(
                      itemBuilder: (context, index) {
                        
                        TodoObject todoObject = todos[index];
                        EdgeInsets padding = const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 30.0);

                        double percentComplete = todoObject.percentComplete();
                        
                        return  Padding(
                          padding: padding,
                          child:  InkWell(
                            onTap: () {
                              
                              Navigator.of(context).push(new PageRouteBuilder(
                                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>  DetailPage(todoObject: todoObject),
                                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child,) {
                                  
                                  return  SlideTransition(
                                    position:  Tween<Offset>(
                                      begin: const Offset(0.0, 1.0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child:  SlideTransition(
                                      position:  Tween<Offset>(
                                        begin: Offset.zero,
                                        end: const Offset(0.0, 1.0),
                                      ).animate(secondaryAnimation),
                                      child: child,
                                    ),
                                  );
                                },
                                transitionDuration: const Duration(milliseconds: 1000)
                              ));
                            },
                            child:  Container(
                              decoration:  BoxDecoration(
                                borderRadius:  BorderRadius.circular(10.0),
                                boxShadow: [
                                   BoxShadow(
                                    color: Colors.black.withAlpha(70),
                                    offset: const Offset(3.0, 10.0),
                                    blurRadius: 15.0
                                  )
                                ]
                              ),
                              height: 250.0,
                              child:  Stack(
                                children: <Widget>[
                                   Hero(
                                    tag: todoObject.uuid + "_background",
                                    child:  Container(
                                      decoration:  BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:  BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                   Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child:  Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                         Expanded(
                                          child:  Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                               Hero(
                                                tag: todoObject.uuid + "_icon",
                                                child:  Container(
                                                  decoration:  BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border:  Border.all(color: Colors.grey.withAlpha(70), style: BorderStyle.solid, width: 1.0),
                                                  ),
                                                  child:  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child:  Icon(todoObject.icon, color: todoObject.color),
                                                  ),
                                                ),
                                              ),
                                               Expanded(
                                                child:  Container(
                                                  alignment: Alignment.topRight,
                                                  child:  Hero(
                                                    tag: todoObject.uuid + "_more_vert",
                                                    child:  Material(
                                                      color: Colors.transparent,
                                                      type: MaterialType.transparency,
                                                      child:  IconButton(
                                                        icon:  Icon(Icons.more_vert, color: Colors.grey,),
                                                        onPressed: () {},
                                                      ),
                                                    ),
                                                  )
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                         Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child:  Align(
                                            alignment: Alignment.bottomLeft,
                                            child:  Hero(
                                              tag: todoObject.uuid + "_number_of_tasks",
                                              child:  Material(
                                                color: Colors.transparent,
                                                child:  Text(
                                                  todoObject.taskAmount().toString() + " Tasks",
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
                                              tag: todoObject.uuid + "_title",
                                              child:  Material(
                                                color: Colors.transparent,
                                                child:  Text(
                                                  todoObject.title,
                                                  style:  TextStyle(
                                                    fontSize: 30.0
                                                  ),
                                                ),
                                              ),
                                            )
                                          ),
                                        ),
                                         Align(
                                          alignment: Alignment.bottomLeft,
                                          child:  Hero(
                                            tag: todoObject.uuid + "_progress_bar",
                                            child:  Material(
                                              color: Colors.transparent,
                                              child:  Row(
                                                children: <Widget>[
                                                   Expanded(
                                                    child:  LinearProgressIndicator(
                                                      value: percentComplete,
                                                      backgroundColor: Colors.grey.withAlpha(50),
                                                      valueColor:  AlwaysStoppedAnimation<Color>(todoObject.color),
                                                    ),
                                                  ),
                                                   Padding(
                                                    padding: const EdgeInsets.only(left: 5.0),
                                                    child:  Text(
                                                      (percentComplete*100).round().toString() + "%"
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          )
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ),
                          )
                        );

                      },
                      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                      scrollDirection: Axis.horizontal,
                      physics:  CustomScrollPhysics(),
                      controller: scrollController,
                      itemExtent: _width - 80,
                      itemCount: todos.length,
                    ),
                  )
                ],
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(right: 15.0, bottom: 15.0),
              child:  Align(
                alignment: Alignment.bottomRight,
                child:  FloatingActionButton(
                  onPressed: () {},
                  tooltip: 'Increment',
                  child:  Icon(Icons.add),
                ),
              ),
            )
          ],
        ),
        )
      ),
    );
  }
}