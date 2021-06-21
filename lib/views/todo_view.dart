import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hivetodoapp/adapters/todo_adapter.dart';
import 'package:hivetodoapp/views/add_todo.dart';
import 'package:url_launcher/url_launcher.dart';

class TodoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[700],
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddTodo()),
          );
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        title:
            Text("Eventer", style: TextStyle(fontFamily: 'Montserrat')),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Todo>('todos').listenable(),
        builder: (context, Box<Todo> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text("No Events Available Yet! Do Something Bruh...",
                  style: TextStyle(fontFamily: 'Montserrat')),
            );
          }
          return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                Todo todo = box.getAt(index);
                return ListTile(
                  leading: IconButton(
                      icon: Icon(
                        Icons.calendar_today_outlined,
                      ),
                      color: Colors.red.shade700,
                      onPressed: () async {
                        const url = 'https://calendar.google.com/calendar/';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      }),
                  onLongPress: () async {
                    await box.deleteAt(index);
                  },
                  title: Text(
                    todo.title,
                    style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
                  ),
                  subtitle: Text(
                    todo.description,
                    style: TextStyle(fontSize: 16, fontFamily: 'Montserrat'),
                  ),
                );
              });
        },
      ),
    );
  }
}
