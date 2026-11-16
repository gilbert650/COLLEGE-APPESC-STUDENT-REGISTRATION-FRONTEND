import 'package:flutter/material.dart';
import '../main.dart';
import 'eligibility_page.dart';
import 'examination_page.dart';
import 'registration_page.dart';

/// Home Page – college logo, title, quick actions
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final student = AppState.currentStudent;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'College APPEC Remera-Rukoma TSS',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Task 2: Image and Asset – College logo
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/college_logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if asset fails to load
                      return Container(
                        color: const Color(0xFF0D47A1),
                        child: const Center(
                          child: Text(
                            'APPEC',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Task 1: Text and Styling – College name & application title
            const Text(
              'College APPEC Remera-Rukoma TSS',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Student Registration &\nOnline Examination System',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'RTQF Level V • Software Development',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 28),

            // Current status card
            if (student != null) ...[
              _buildStatusCard(student.eligibilityStatus),
              const SizedBox(height: 20),
            ],

            // Quick action buttons (Task 3: Interactive Widgets)
            _buildActionButton(
              context,
              icon: Icons.person_add_alt_1,
              label: 'Register Student',
              color: const Color(0xFF0D47A1),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegistrationPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              context,
              icon: Icons.fact_check,
              label: 'Check Eligibility',
              color: Colors.teal,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EligibilityPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              context,
              icon: Icons.quiz,
              label: 'Start Examination',
              color: Colors.deepOrange,
              onPressed: () {
                _tryStartExam(context);
              },
            ),
            const SizedBox(height: 24),

            // Info box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How it works',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '1. Register your personal & academic details\n'
                    '2. Declare school feeding & library clearance\n'
                    '3. Wait for administration verification\n'
                    '4. Sit for the online examination when Eligible',
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String status) {
    Color bg;
    Color fg;
    IconData icon;

    switch (status) {
      case 'Eligible':
        bg = Colors.green.shade50;
        fg = Colors.green.shade800;
        icon = Icons.check_circle;
        break;
      case 'Not Eligible':
        bg = Colors.red.shade50;
        fg = Colors.red.shade800;
        icon = Icons.cancel;
        break;
      default:
        bg = Colors.orange.shade50;
        fg = Colors.orange.shade800;
        icon = Icons.hourglass_empty;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: fg.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: fg, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Eligibility Status',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 22),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _tryStartExam(BuildContext context) {
    final student = AppState.currentStudent;

    if (student == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please register first before starting an examination.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Task 8: Prevent unverified or ineligible students from starting examinations
    if (student.eligibilityStatus != 'Eligible' || !student.isAdminVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            student.eligibilityStatus == 'Pending Verification'
                ? 'Your eligibility is still Pending Verification. Wait for administration approval.'
                : 'You are Not Eligible. Clear outstanding obligations and get admin verification.',
          ),
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ExaminationPage()),
    );
  }
}
