import 'package:flutter/material.dart';
import '../main.dart';
import 'eligibility_page.dart';
import 'registration_page.dart';

/// Student Profile Page
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final student = AppState.currentStudent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        centerTitle: true,
      ),
      body: student == null
          ? _buildEmptyState(context)
          : _buildProfile(context, student),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'No student registered',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Register first to view your profile.',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegistrationPage(),
                  ),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Register Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(BuildContext context, dynamic student) {
    Color statusColor;
    IconData statusIcon;

    switch (student.eligibilityStatus) {
      case 'Eligible':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Not Eligible':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Avatar + name
          CircleAvatar(
            radius: 48,
            backgroundColor: const Color(0xFF0D47A1),
            child: Text(
              student.fullName.isNotEmpty
                  ? student.fullName[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            student.fullName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            student.registrationNumber,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Chip(
            avatar: Icon(statusIcon, color: statusColor, size: 18),
            label: Text(
              student.eligibilityStatus,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: statusColor.withOpacity(0.12),
          ),
          const SizedBox(height: 24),

          // Details card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _detailTile(Icons.work, 'Trade', student.trade),
                  const Divider(),
                  _detailTile(Icons.school, 'Level', student.level),
                  const Divider(),
                  _detailTile(Icons.wc, 'Gender', student.gender),
                  const Divider(),
                  _detailTile(Icons.phone, 'Contact', student.contact),
                  const Divider(),
                  _detailTile(
                    Icons.restaurant,
                    'School Feeding',
                    student.schoolFeedingCleared ? 'Cleared' : 'Not cleared',
                  ),
                  const Divider(),
                  _detailTile(
                    Icons.library_books,
                    'Library',
                    student.libraryCleared ? 'Cleared' : 'Not cleared',
                  ),
                  const Divider(),
                  _detailTile(
                    Icons.verified_user,
                    'Admin Verified',
                    student.isAdminVerified ? 'Yes' : 'No',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Actions
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EligibilityPage()),
              );
            },
            icon: const Icon(Icons.fact_check),
            label: const Text('Check / Update Eligibility'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Reset Data?'),
                  content: const Text(
                    'This will clear the current student registration and eligibility data. Continue?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        AppState.reset();
                        Navigator.pop(ctx);
                        // Force rebuild by navigating to home via named route
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.refresh, color: Colors.red),
            label: const Text(
              'Reset Registration',
              style: TextStyle(color: Colors.red),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              side: const BorderSide(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0D47A1), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
