import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(DailyPlannerApp());
}

class DailyPlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daily Planner',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: PlannerScreen(),
    );
  }
}

class PlannerScreen extends StatefulWidget {
  @override
  _PlannerScreenState createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final Map<String, List<Map<String, dynamic>>> _tasksByDate = {};
  final TextEditingController _taskController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      String dateKey = DateFormat('yyyy-MM-dd').format(_selectedDate);
      setState(() {
        if (!_tasksByDate.containsKey(dateKey)) {
          _tasksByDate[dateKey] = [];
        }
        _tasksByDate[dateKey]!.add({
          'title': _taskController.text,
          'completed': false,
        });
      });
      _taskController.clear();
    }
  }

  void _toggleTask(String dateKey, int index) {
    setState(() {
      _tasksByDate[dateKey]![index]['completed'] =
          !_tasksByDate[dateKey]![index]['completed'];
    });
  }

  void _removeTask(String dateKey, int index) {
    setState(() {
      _tasksByDate[dateKey]!.removeAt(index);
      if (_tasksByDate[dateKey]!.isEmpty) {
        _tasksByDate.remove(dateKey);
      }
    });
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 7)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String dateKey = DateFormat('yyyy-MM-dd').format(_selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Planner'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Daily Planner'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: 'Enter task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: _pickDate,
                  child: Text('Pick Date'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasksByDate[dateKey]?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: _tasksByDate[dateKey]![index]['completed'],
                    onChanged: (value) => _toggleTask(dateKey, index),
                  ),
                  title: Text(
                    _tasksByDate[dateKey]![index]['title'],
                    style: TextStyle(
                      decoration: _tasksByDate[dateKey]![index]['completed']
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeTask(dateKey, index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Daily Planner'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Daily Planner',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Daily Planner is a simple and efficient task management app. '
              'It allows users to schedule tasks, set reminders, and organize their daily activities effectively.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Credits',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Developed by Vitalii, Eugen, Artem and Nursaya in the scope of the course '
              '“Crossplatform Development” at Astana IT University.\n'
              'Assistant Professor Abzal Kyzyrkanov.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
