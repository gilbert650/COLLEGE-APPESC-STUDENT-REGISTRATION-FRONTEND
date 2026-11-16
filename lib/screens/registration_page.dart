import 'package:flutter/material.dart';
import '../main.dart';
import '../models/student.dart';
import 'eligibility_page.dart';

/// Student Registration Page (Task 1 modules + Task 8 Form Validation)
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _regNumberController = TextEditingController();
  final _contactController = TextEditingController();

  String? _selectedTrade;
  String? _selectedLevel;
  String? _selectedGender;

  final List<String> _trades = [
    'Software Development',
    'Networking',
    'Multimedia',
    'Accounting',
    'Hospitality',
  ];

  final List<String> _levels = [
    'RTQF Level 3',
    'RTQF Level 4',
    'RTQF Level 5',
  ];

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    // Pre-fill if student already registered (for demo / editing)
    final s = AppState.currentStudent;
    if (s != null) {
      _fullNameController.text = s.fullName;
      _regNumberController.text = s.registrationNumber;
      _contactController.text = s.contact;
      _selectedTrade = s.trade;
      _selectedLevel = s.level;
      _selectedGender = s.gender;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _regNumberController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _submitRegistration() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in the form.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create student with Pending Verification (admin must still approve)
    final student = Student(
      fullName: _fullNameController.text.trim(),
      registrationNumber: _regNumberController.text.trim(),
      trade: _selectedTrade!,
      level: _selectedLevel!,
      gender: _selectedGender!,
      contact: _contactController.text.trim(),
      schoolFeedingCleared: false,
      libraryCleared: false,
      isAdminVerified: false,
      eligibilityStatus: 'Pending Verification',
    );

    AppState.currentStudent = student;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration successful! Proceed to Eligibility Check.'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to Eligibility page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EligibilityPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Registration'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D47A1).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.person_add, color: Color(0xFF0D47A1), size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Enter your personal and academic information',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Full Name
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                  prefixIcon: Icon(Icons.person),
                  hintText: 'e.g. Jean Baptiste Niyonzima',
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Full name is required';
                  }
                  if (value.trim().split(' ').length < 2) {
                    return 'Please enter at least first and last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Registration Number
              TextFormField(
                controller: _regNumberController,
                decoration: const InputDecoration(
                  labelText: 'Registration Number *',
                  prefixIcon: Icon(Icons.badge),
                  hintText: 'e.g. APPEC/SD/2024/001',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Registration number is required';
                  }
                  if (value.trim().length < 5) {
                    return 'Registration number is too short';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Trade (Dropdown)
              DropdownButtonFormField<String>(
                value: _selectedTrade,
                decoration: const InputDecoration(
                  labelText: 'Trade *',
                  prefixIcon: Icon(Icons.work),
                ),
                items: _trades
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedTrade = val),
                validator: (value) =>
                    value == null ? 'Please select a trade' : null,
              ),
              const SizedBox(height: 16),

              // Level
              DropdownButtonFormField<String>(
                value: _selectedLevel,
                decoration: const InputDecoration(
                  labelText: 'Level *',
                  prefixIcon: Icon(Icons.school),
                ),
                items: _levels
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedLevel = val),
                validator: (value) =>
                    value == null ? 'Please select a level' : null,
              ),
              const SizedBox(height: 16),

              // Gender – Radio buttons (Task 3)
              const Text(
                'Gender *',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              FormField<String>(
                validator: (value) {
                  if (_selectedGender == null) {
                    return 'Please select gender';
                  }
                  return null;
                },
                builder: (state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: _genders.map((g) {
                          return Expanded(
                            child: RadioListTile<String>(
                              title: Text(g, style: const TextStyle(fontSize: 14)),
                              value: g,
                              groupValue: _selectedGender,
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (val) {
                                setState(() {
                                  _selectedGender = val;
                                  state.didChange(val);
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      if (state.hasError)
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 4),
                          child: Text(
                            state.errorText!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 8),

              // Contact
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact (Phone / Email) *',
                  prefixIcon: Icon(Icons.phone),
                  hintText: 'e.g. 078XXXXXXX or email@example.com',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Contact information is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),

              // Submit button
              ElevatedButton.icon(
                onPressed: _submitRegistration,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Register Student',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
