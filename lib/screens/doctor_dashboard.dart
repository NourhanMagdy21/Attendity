import 'package:flutter/material.dart';
import 'package:locate_me/services/course_service.dart';

class DoctorDashboard extends StatefulWidget {
  final Map<String, dynamic> doctorData;

  const DoctorDashboard({
    Key? key,
    required this.doctorData,
  }) : super(key: key);

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  final _courseNameController = TextEditingController();
  final _courseCodeController = TextEditingController();
  final _courseDescriptionController = TextEditingController();
  final _courseDayController = TextEditingController();
  final _courseTimeController = TextEditingController();

  List<Map<String, dynamic>> courses = [];
  bool _isLoading = false;

  final CourseService _courseService = CourseService();

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _courseCodeController.dispose();
    _courseDescriptionController.dispose();
    _courseDayController.dispose();
    _courseTimeController.dispose();
    super.dispose();
  }

  Future<void> _loadCourses() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _courseService.getDoctorCourses(widget.doctorData['id']);
      if (response['success']) {
        setState(() {
          courses = List<Map<String, dynamic>>.from(response['courses']);
        });
      } else {
        _showSnackBar(response['message'], Colors.red);
      }
    } catch (e) {
      _showSnackBar('Error loading courses: $e', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addCourse() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Course'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _courseNameController,
                decoration: const InputDecoration(labelText: 'Course Name'),
              ),
              TextField(
                controller: _courseCodeController,
                decoration: const InputDecoration(labelText: 'Course Code'),
              ),
              TextField(
                controller: _courseDayController,
                decoration: const InputDecoration(labelText: 'Course Day'),
              ),
              TextField(
                controller: _courseTimeController,
                decoration: const InputDecoration(labelText: 'Course Time'),
              ),
              TextField(
                controller: _courseDescriptionController,
                decoration: const InputDecoration(labelText: 'Additional Notes'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (_courseNameController.text.isEmpty ||
                  _courseCodeController.text.isEmpty ||
                  _courseDayController.text.isEmpty ||
                  _courseTimeController.text.isEmpty) {
                _showSnackBar('Please fill all required fields', Colors.red);
                return;
              }

              setState(() {
                _isLoading = true;
              });

              try {
                final response = await _courseService.addCourse(
                  code: _courseCodeController.text,
                  name: _courseNameController.text,
                  day: _courseDayController.text,
                  time: _courseTimeController.text,
                  description: _courseDescriptionController.text,
                  doctorId: widget.doctorData['id'],
                );

                if (response['success']) {
                  _courseNameController.clear();
                  _courseCodeController.clear();
                  _courseDayController.clear();
                  _courseTimeController.clear();
                  _courseDescriptionController.clear();
                  Navigator.pop(context);
                  _showSnackBar(
                      'Course added successfully. Enrollment code: ${response['course']['enrollment_code']}',
                      Colors.green);
                  _loadCourses();
                } else {
                  _showSnackBar(response['message'], Colors.red);
                }
              } catch (e) {
                _showSnackBar('Error adding course: $e', Colors.red);
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCourses,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : courses.isEmpty
          ? const Center(child: Text('No courses available'))
          : ListView.builder(
        itemCount: courses.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final course = courses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course['name'] ?? 'Unknown Name',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Day: ${course['day'] ?? 'N/A'}"),
                  Text("Time: ${course['time'] ?? 'N/A'}"),
                  Text("Code: ${course['enrollment_code'] ?? 'N/A'}"),
                  Text("${course['students'] ?? 0} students"),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCourse,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}