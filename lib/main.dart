import 'package:flutter/material.dart';
import 'models/student.dart';
import 'screens/home_page.dart';
import 'screens/registration_page.dart';
import 'screens/eligibility_page.dart';
import 'screens/examination_page.dart';
import 'screens/profile_page.dart';
import 'screens/main_scaffold.dart';

void main() {
  runApp(const StudentExamApp());
}

class StudentExamApp extends StatelessWidget {
  const StudentExamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Registration & Exam System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF0D47A1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1),
          primary: const Color(0xFF0D47A1),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D47A1),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D47A1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 2),
          ),
        ),
      ),
      // Named routes (Task 5: Navigator and Route)
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScaffold(),
        '/home': (context) => const HomePage(),
        '/registration': (context) => const RegistrationPage(),
        '/eligibility': (context) => const EligibilityPage(),
        '/examination': (context) => const ExaminationPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}

/// Global simple in-memory store so data persists while the app is running.
/// (Database is not required for this practical assessment.)
class AppState {
  static Student? currentStudent;
  static bool examSubmitted = false;

  static void reset() {
    currentStudent = null;
    examSubmitted = false;
  }
}
