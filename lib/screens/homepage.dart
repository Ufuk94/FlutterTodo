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
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  ScrollController scrollController;
  Color backgroundColor;
  Tween<Color> colorTween;
  int currentPage = 0;
  Color constBackColor;

  @override
  void initState() {
    colorTween = new ColorTween(begin: ColorChoies.colors[0], end: ColorChoies.colors[1]);
    backgroundColor = todos[0].color;
    scrollController = new ScrollController();
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

    

    return new Container(
      decoration: new BoxDecoration(
        color: backgroundColor
      ),
      child: new Scaffold(
        backgroundColor: Colors.transparent,
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: new Text("TODO"),
          leading: new IconButton(
            icon: new Icon(CustomIcons.menu),
            onPressed: () {},
          ),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(CustomIcons.search, size: 26.0,),
              onPressed: () {},
            )
          ],
        ),
        body: new Container(
          child: new Stack(
          children: <Widget>[
            new Container(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 50.0, right: 60.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(bottom: 25.0),
                          child: new Container(
                            decoration: new BoxDecoration(
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.black38,
                                  offset: new Offset(5.0, 5.0),
                                  blurRadius: 15.0
                                )
                              ],
                              shape: BoxShape.circle,
                            ),
                            child: new CircleAvatar(
                              backgroundColor: Colors.grey,
                            ),
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: new Text(
                            "Hello, John.",
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 30.0
                            ),
                          ),
                        ),
                        new Text(
                          "This is a daily quote.",
                          style: new TextStyle(
                            color: Colors.white70
                          ),
                        ),
                        new Text(
                          "You have 10 tasks to do today.",
                          style: new TextStyle(
                            color: Colors.white70
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    height: 350.0,
                    width: _width,
                    child: new ListView.builder(
                      itemBuilder: (context, index) {
                        
                        TodoObject todoObject = todos[index];
                        EdgeInsets padding = const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 30.0);

                        double percentComplete = todoObject.percentComplete();
                        
                        return new Padding(
                          padding: padding,
                          child: new InkWell(
                            onTap: () {
                              
                              Navigator.of(context).push(new PageRouteBuilder(
                                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => new DetailPage(todoObject: todoObject),
                                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child,) {
                                  
                                  return new SlideTransition(
                                    position: new Tween<Offset>(
                                      begin: const Offset(0.0, 1.0),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: new SlideTransition(
                                      position: new Tween<Offset>(
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
                            child: new Container(
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.circular(10.0),
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.black.withAlpha(70),
                                    offset: const Offset(3.0, 10.0),
                                    blurRadius: 15.0
                                  )
                                ]
                              ),
                              height: 250.0,
                              child: new Stack(
                                children: <Widget>[
                                  new Hero(
                                    tag: todoObject.uuid + "_background",
                                    child: new Container(
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: new BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: new Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Expanded(
                                          child: new Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Hero(
                                                tag: todoObject.uuid + "_icon",
                                                child: new Container(
                                                  decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: new Border.all(color: Colors.grey.withAlpha(70), style: BorderStyle.solid, width: 1.0),
                                                  ),
                                                  child: new Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: new Icon(todoObject.icon, color: todoObject.color),
                                                  ),
                                                ),
                                              ),
                                              new Expanded(
                                                child: new Container(
                                                  alignment: Alignment.topRight,
                                                  child: new Hero(
                                                    tag: todoObject.uuid + "_more_vert",
                                                    child: new Material(
                                                      color: Colors.transparent,
                                                      type: MaterialType.transparency,
                                                      child: new IconButton(
                                                        icon: new Icon(Icons.more_vert, color: Colors.grey,),
                                                        onPressed: () {},
                                                      ),
                                                    ),
                                                  )
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        new Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: new Align(
                                            alignment: Alignment.bottomLeft,
                                            child: new Hero(
                                              tag: todoObject.uuid + "_number_of_tasks",
                                              child: new Material(
                                                color: Colors.transparent,
                                                child: new Text(
                                                  todoObject.taskAmount().toString() + " Tasks",
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
                                              tag: todoObject.uuid + "_title",
                                              child: new Material(
                                                color: Colors.transparent,
                                                child: new Text(
                                                  todoObject.title,
                                                  style: new TextStyle(
                                                    fontSize: 30.0
                                                  ),
                                                ),
                                              ),
                                            )
                                          ),
                                        ),
                                        new Align(
                                          alignment: Alignment.bottomLeft,
                                          child: new Hero(
                                            tag: todoObject.uuid + "_progress_bar",
                                            child: new Material(
                                              color: Colors.transparent,
                                              child: new Row(
                                                children: <Widget>[
                                                  new Expanded(
                                                    child: new LinearProgressIndicator(
                                                      value: percentComplete,
                                                      backgroundColor: Colors.grey.withAlpha(50),
                                                      valueColor: new AlwaysStoppedAnimation<Color>(todoObject.color),
                                                    ),
                                                  ),
                                                  new Padding(
                                                    padding: const EdgeInsets.only(left: 5.0),
                                                    child: new Text(
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
                      physics: new CustomScrollPhysics(),
                      controller: scrollController,
                      itemExtent: _width - 80,
                      itemCount: todos.length,
                    ),
                  )
                ],
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(right: 15.0, bottom: 15.0),
              child: new Align(
                alignment: Alignment.bottomRight,
                child: new FloatingActionButton(
                  onPressed: () {},
                  tooltip: 'Increment',
                  child: new Icon(Icons.add),
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