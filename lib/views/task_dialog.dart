import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/models/task.dart';

class TaskDialog extends StatefulWidget {
  final Task task;

  TaskDialog({this.task});

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  int _priority = null;
  var _keyForm = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Task _currentTask = Task();

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _currentTask = Task.fromMap(widget.task.toMap());
    }

    _titleController.text = _currentTask.title;
    _descriptionController.text = _currentTask.description;
    _priority = _currentTask.priority;
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyForm,
      child: AlertDialog(
        title: Text(widget.task == null ? 'New task' : 'Edit task'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
                validator: (text) {
                  return text.isEmpty ? "Add a title" : null;
                },
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                autofocus: true),
            TextFormField(
                validator: (text) {
                  return text.isEmpty ? "Add a description" : null;
                },
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description')),
            DropdownButtonFormField<int>(
              hint: Text("Set a priority"),
              value: _priority,
              onChanged: (int newValue) {
                setState(() {
                  _priority = newValue;
                });
              },
              validator: (int value) {
                if (value == null) {
                  return "Set a priority";
                } else if (value < 1 || value > 5) {
                  return "Priority should be between 0 and 5";
                } return null;
              },
              items: _currentTask
                  .getPriorities()
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Save'),
            onPressed: () {
              if (_keyForm.currentState.validate()) {
                _currentTask.title = _titleController.value.text;
                _currentTask.description = _descriptionController.text;
                _currentTask.priority = _priority;
                Navigator.of(context).pop(_currentTask);
              }
            },
          ),
        ],
      ),
    );
  }
}
