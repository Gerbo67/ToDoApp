import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/todo_service.dart';

class TodosByCategory extends StatefulWidget {
  final String category;
  TodosByCategory({this.category});
  @override
  _TodosByCategoryState createState() => _TodosByCategoryState();
}

class _TodosByCategoryState extends State<TodosByCategory> {
  List<Todo> _todoList = List<Todo>.empty(growable: true);
  TodoService _todoService = TodoService();


  getTodosByCategory() async{
    var todos = await _todoService.todosByCategory(this.widget.category);
    todos.forEach(
            (todo){
          setState(() {
            var model = Todo();
            model.title = todo["title"];
            _todoList.add(model);
          });
        }
    );
  }

  @override
  void initState() {
    super.initState();
    getTodosByCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos by category"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 1,child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0, 0), blurRadius: 1.0, spreadRadius: 0.0)],
                color: Colors.blueGrey,
                borderRadius: BorderRadius.all(Radius.circular(3.0))
            ),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(4.0),
            child: Text(this.widget.category,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white)),
          )),
          Expanded(flex:12,child:
          ListView.builder(
              itemCount: _todoList.length,
              itemBuilder: (context, index){
                return Card(
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_todoList[index].title ?? "No title"),
                      ],
                    ),
                  ),
                );
              }),
          ),
        ],
      ),

    );
  }
}
