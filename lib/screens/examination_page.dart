import 'package:flutter/material.dart';
import '../main.dart';

/// Online Examination Page with TabBar (Task 7)
class ExaminationPage extends StatefulWidget {
  const ExaminationPage({super.key});

  @override
  State<ExaminationPage> createState() => _ExaminationPageState();
}

class _ExaminationPageState extends State<ExaminationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample multiple-choice questions
  final List<Map<String, dynamic>> _questions = [
    {
      'id': 1,
      'question': 'What is Flutter?',
      'options': [
        'A programming language',
        'An open-source UI software development kit by Google',
        'A database management system',
        'An operating system',
      ],
      'correctIndex': 1,
    },
    {
      'id': 2,
      'question': 'Which widget is used for navigation between screens in Flutter?',
      'options': [
        'Container',
        'Navigator',
        'TextField',
        'ListView',
      ],
      'correctIndex': 1,
    },
    {
      'id': 3,
      'question': 'What does the BottomNavigationBar widget provide?',
      'options': [
        'A top app bar',
        'A floating action button',
        'Navigation between top-level views using icons and labels',
        'Form validation',
      ],
      'correctIndex': 2,
    },
    {
      'id': 4,
      'question': 'Which of the following is used for form validation in Flutter?',
      'options': [
        'Form + GlobalKey + validator',
        'Only TextField',
        'Image.asset',
        'TabBar',
      ],
      'correctIndex': 0,
    },
    {
      'id': 5,
      'question': 'What is the purpose of Image.asset() in Flutter?',
      'options': [
        'To load images from the internet',
        'To display images packaged in the application assets',
        'To take photos with the camera',
        'To crop images',
      ],
      'correctIndex': 1,
    },
  ];

  // Selected answers (index of chosen option, -1 = not answered)
  late List<int> _selectedAnswers;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedAnswers = List.filled(_questions.length, -1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _submitExam() {
    // Check if all questions answered
    final unanswered = _selectedAnswers.where((a) => a == -1).length;
    if (unanswered > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please answer all questions. $unanswered question(s) remaining.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Calculate score
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_selectedAnswers[i] == _questions[i]['correctIndex']) {
        score++;
      }
    }

    AppState.examSubmitted = true;

    // Task 8: Display confirmation message after successful submission
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 10),
            Text('Exam Submitted'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your examination responses have been submitted successfully.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            Text(
              'Score: $score / ${_questions.length}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Student: ${AppState.currentStudent?.fullName ?? "N/A"}',
              style: const TextStyle(fontSize: 13),
            ),
            Text(
              'Reg No: ${AppState.currentStudent?.registrationNumber ?? "N/A"}',
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // close dialog
              Navigator.of(context).pop(); // go back
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = AppState.currentStudent;

    // Extra guard – should already be blocked from Home / Eligibility
    if (student == null ||
        student.eligibilityStatus != 'Eligible' ||
        !student.isAdminVerified) {
      return Scaffold(
        appBar: AppBar(title: const Text('Examination')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Access denied. Only eligible and administration-approved students may sit for the examination.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Examination'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.info_outline), text: 'Instructions'),
            Tab(icon: Icon(Icons.quiz), text: 'Questions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ===== TAB 1: Instructions =====
          _buildInstructionsTab(),

          // ===== TAB 2: Questions =====
          _buildQuestionsTab(),
        ],
      ),
    );
  }

  Widget _buildInstructionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0D47A1).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(Icons.school, size: 48, color: Color(0xFF0D47A1)),
                const SizedBox(height: 10),
                const Text(
                  'College APPEC Remera-Rukoma TSS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Flutter Practical Assessment – Online Exam',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Examination Instructions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 12),
          _instructionItem('1', 'This examination contains 5 multiple-choice questions.'),
          _instructionItem('2', 'Each question has only one correct answer.'),
          _instructionItem('3', 'Select your answer by tapping the radio button next to the option.'),
          _instructionItem('4', 'You must answer all questions before submitting.'),
          _instructionItem('5', 'Once submitted, answers cannot be changed.'),
          _instructionItem('6', 'Do not refresh or close the application during the exam.'),
          _instructionItem('7', 'Good luck!'),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _tabController.animateTo(1),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Go to Questions'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _instructionItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: const Color(0xFF0D47A1),
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsTab() {
    return Column(
      children: [
        // Progress indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.blue.shade50,
          child: Row(
            children: [
              const Icon(Icons.assignment, color: Color(0xFF0D47A1)),
              const SizedBox(width: 8),
              Text(
                'Answered: ${_selectedAnswers.where((a) => a != -1).length} / ${_questions.length}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _questions.length,
            itemBuilder: (context, index) {
              final q = _questions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${index + 1}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF0D47A1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        q['question'] as String,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(
                        (q['options'] as List).length,
                        (optIndex) {
                          return RadioListTile<int>(
                            title: Text(
                              q['options'][optIndex],
                              style: const TextStyle(fontSize: 14),
                            ),
                            value: optIndex,
                            groupValue: _selectedAnswers[index],
                            activeColor: const Color(0xFF0D47A1),
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) {
                              setState(() {
                                _selectedAnswers[index] = val!;
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Submit button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ElevatedButton.icon(
            onPressed: _submitExam,
            icon: const Icon(Icons.send),
            label: const Text(
              'Submit Examination',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
        ),
      ],
    );
  }
}
