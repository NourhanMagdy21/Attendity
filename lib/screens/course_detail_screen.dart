import 'package:flutter/material.dart';

class CourseDetailScreen extends StatelessWidget {
  // Make the course parameter optional since we'll extract it from route arguments
  final Map<String, dynamic>? course;
  
  const CourseDetailScreen({
    Key? key,
    this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract the course from route arguments if not provided directly
    final Map<String, dynamic> courseData = course ?? 
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>);
        
    return Scaffold(
      appBar: AppBar(
        title: Text(courseData['name']),
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course code and section
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Course Code',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          courseData['code'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Section',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          courseData['section'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Course description
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      courseData['description'] ?? 'No description available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Instructor information
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instructor',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      courseData['instructor_name'] ?? 'Not assigned',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    if (courseData['instructor_email'] != null) ...[  
                      const SizedBox(height: 4),
                      Text(
                        courseData['instructor_email'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Attendance button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement attendance functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Attendance feature coming soon'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  'Take Attendance',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // View materials button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Course materials feature coming soon'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.book_outlined),
                label: const Text(
                  'View Course Materials',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}