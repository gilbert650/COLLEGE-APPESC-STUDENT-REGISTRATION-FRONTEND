import 'package:flutter/material.dart';
import '../main.dart';
import '../models/student.dart';
import 'examination_page.dart';

/// Examination Eligibility Checking Page
class EligibilityPage extends StatefulWidget {
  const EligibilityPage({super.key});

  @override
  State<EligibilityPage> createState() => _EligibilityPageState();
}

class _EligibilityPageState extends State<EligibilityPage> {
  bool _schoolFeedingCleared = false;
  bool _libraryCleared = false;
  bool _adminVerified = false; // Simulated admin verification toggle

  @override
  void initState() {
    super.initState();
    final s = AppState.currentStudent;
    if (s != null) {
      _schoolFeedingCleared = s.schoolFeedingCleared;
      _libraryCleared = s.libraryCleared;
      _adminVerified = s.isAdminVerified;
    }
  }

  void _updateEligibility() {
    final student = AppState.currentStudent;
    if (student == null) return;

    final status = Student.calculateEligibility(
      schoolFeedingCleared: _schoolFeedingCleared,
      libraryCleared: _libraryCleared,
      isAdminVerified: _adminVerified,
    );

    AppState.currentStudent = student.copyWith(
      schoolFeedingCleared: _schoolFeedingCleared,
      libraryCleared: _libraryCleared,
      isAdminVerified: _adminVerified,
      eligibilityStatus: status,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final student = AppState.currentStudent;

    if (student == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Eligibility Check')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'No student registered yet.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back & Register'),
              ),
            ],
          ),
        ),
      );
    }

    final status = AppState.currentStudent!.eligibilityStatus;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Examination Eligibility'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Student summary
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Student Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    const Divider(),
                    _infoRow('Full Name', student.fullName),
                    _infoRow('Reg. Number', student.registrationNumber),
                    _infoRow('Trade', student.trade),
                    _infoRow('Level', student.level),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Clearance section – Checkboxes (Task 3)
            const Text(
              'School Obligations Clearance',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Indicate whether you have cleared the following obligations. '
              'Note: Final approval is done by school administration.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 12),

            CheckboxListTile(
              title: const Text('School Feeding cleared'),
              subtitle: const Text('No outstanding school feeding payments'),
              value: _schoolFeedingCleared,
              activeColor: const Color(0xFF0D47A1),
              onChanged: (val) {
                setState(() {
                  _schoolFeedingCleared = val ?? false;
                  // When student changes declaration, reset admin verification
                  _adminVerified = false;
                });
                _updateEligibility();
              },
            ),
            CheckboxListTile(
              title: const Text('Library cleared'),
              subtitle: const Text('No unreturned books or unpaid library fines'),
              value: _libraryCleared,
              activeColor: const Color(0xFF0D47A1),
              onChanged: (val) {
                setState(() {
                  _libraryCleared = val ?? false;
                  _adminVerified = false;
                });
                _updateEligibility();
              },
            ),

            const SizedBox(height: 16),

            // Simulated Admin Verification (important system rule)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.admin_panel_settings, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'Administration Verification',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Students cannot approve their own eligibility. '
                    'Only school administration can confirm clearance.',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text(
                      'Verified by Administration',
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      _adminVerified
                          ? 'Status has been confirmed by admin'
                          : 'Awaiting admin confirmation',
                      style: const TextStyle(fontSize: 12),
                    ),
                    value: _adminVerified,
                    activeColor: Colors.green,
                    onChanged: (val) {
                      setState(() => _adminVerified = val);
                      _updateEligibility();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Eligibility Status display (Task 1 – text styling)
            _buildEligibilityStatusCard(status),

            const SizedBox(height: 24),

            // Decision table reminder
            _buildDecisionTable(),

            const SizedBox(height: 24),

            // Action buttons
            if (status == 'Eligible' && _adminVerified)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ExaminationPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.quiz),
                label: const Text('Proceed to Examination'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  minimumSize: const Size(double.infinity, 50),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.lock),
                label: Text(
                  status == 'Pending Verification'
                      ? 'Waiting for Admin Verification'
                      : 'Not Eligible – Resolve Obligations',
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),

            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEligibilityStatusCard(String status) {
    Color bg;
    Color fg;
    IconData icon;
    String message;

    switch (status) {
      case 'Eligible':
        bg = Colors.green.shade50;
        fg = Colors.green.shade800;
        icon = Icons.check_circle;
        message = 'You have cleared all required obligations and have been approved by administration. You may sit for the examination.';
        break;
      case 'Not Eligible':
        bg = Colors.red.shade50;
        fg = Colors.red.shade800;
        icon = Icons.cancel;
        message = 'You have outstanding school feeding or library obligations. Please resolve them and request admin verification.';
        break;
      default:
        bg = Colors.orange.shade50;
        fg = Colors.orange.shade800;
        icon = Icons.hourglass_top;
        message = 'Your information requires confirmation by the school administration. Please wait for verification.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fg.withOpacity(0.35), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: fg),
          const SizedBox(height: 10),
          Text(
            status,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: fg.withOpacity(0.9)),
          ),
        ],
      ),
    );
  }

  Widget _buildDecisionTable() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Eligibility Decision Rules',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Table(
            border: TableBorder.all(color: Colors.grey.shade300, width: 0.5),
            columnWidths: const {
              0: FlexColumnWidth(1.2),
              1: FlexColumnWidth(1.2),
              2: FlexColumnWidth(1.6),
            },
            children: const [
              TableRow(
                decoration: BoxDecoration(color: Color(0xFF0D47A1)),
                children: [
                  Padding(
                    padding: EdgeInsets.all(6),
                    child: Text('School Feeding',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(6),
                    child: Text('Library',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(6),
                    child: Text('Result',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              TableRow(children: [
                Padding(padding: EdgeInsets.all(6), child: Text('Cleared', style: TextStyle(fontSize: 11))),
                Padding(padding: EdgeInsets.all(6), child: Text('Cleared', style: TextStyle(fontSize: 11))),
                Padding(padding: EdgeInsets.all(6), child: Text('Eligible*', style: TextStyle(fontSize: 11))),
              ]),
              TableRow(children: [
                Padding(padding: EdgeInsets.all(6), child: Text('Not cleared', style: TextStyle(fontSize: 11))),
                Padding(padding: EdgeInsets.all(6), child: Text('Any', style: TextStyle(fontSize: 11))),
                Padding(padding: EdgeInsets.all(6), child: Text('Not Eligible', style: TextStyle(fontSize: 11))),
              ]),
              TableRow(children: [
                Padding(padding: EdgeInsets.all(6), child: Text('Any', style: TextStyle(fontSize: 11))),
                Padding(padding: EdgeInsets.all(6), child: Text('Not cleared', style: TextStyle(fontSize: 11))),
                Padding(padding: EdgeInsets.all(6), child: Text('Not Eligible', style: TextStyle(fontSize: 11))),
              ]),
              TableRow(children: [
                Padding(padding: EdgeInsets.all(6), child: Text('Unverified', style: TextStyle(fontSize: 11))),
                Padding(padding: EdgeInsets.all(6), child: Text('Any', style: TextStyle(fontSize: 11))),
                Padding(padding: EdgeInsets.all(6), child: Text('Pending', style: TextStyle(fontSize: 11))),
              ]),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            '* Subject to administration approval',
            style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
