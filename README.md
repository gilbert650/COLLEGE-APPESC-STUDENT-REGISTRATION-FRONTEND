# Student Registration & Online Examination Management System

**College APPEC Remera-Rukoma TSS**  
**Trade:** Software Development · **Level:** RTQF Level V · **Technology:** Flutter  
**Assessment Type:** Practical Assessment · **Total Marks:** 20

---

## Overview

This Flutter mobile application allows students to:

1. Register personal and academic information  
2. Declare school feeding & library clearance status  
3. Check examination eligibility (with administration verification)  
4. Access online examinations **only** when Eligible + Admin-approved  
5. View exam instructions and answer multiple-choice questions  
6. Submit examination responses and receive confirmation  

Database integration and real payment verification are **not required**.

---

## How to Run

```bash
# 1. Open the project folder in VS Code / Android Studio
cd student_exam_app

# 2. Get dependencies
flutter pub get

# 3. Run on emulator or connected device
flutter run
```

> Make sure Flutter SDK is installed and `flutter doctor` is clean.

---

## Project Structure

```
student_exam_app/
├── assets/
│   └── images/
│       └── college_logo.png      # College logo (Image.asset)
├── lib/
│   ├── main.dart                 # App entry + named routes + AppState
│   ├── models/
│   │   └── student.dart          # Student model + eligibility logic
│   └── screens/
│       ├── main_scaffold.dart    # BottomNavigationBar host
│       ├── home_page.dart        # Logo, title, quick actions
│       ├── registration_page.dart
│       ├── eligibility_page.dart
│       ├── examination_page.dart # TabBar + TabBarView
│       └── profile_page.dart
├── pubspec.yaml
└── README.md
```

---

## Assessment Criteria Coverage

| No. | Criteria                        | Marks | Implementation |
|-----|---------------------------------|-------|----------------|
| 1   | Text and Styling                | 2     | College name, app title, eligibility status with colors & font weights |
| 2   | Image and Asset                 | 2     | `Image.asset('assets/images/college_logo.png')` on Home Page |
| 3   | Interactive Widgets             | 3     | ElevatedButtons, CheckBoxes, RadioButtons |
| 4   | Layout Widgets                  | 3     | Row, Column, Container, Expanded, Card, Padding |
| 5   | Navigator and Route             | 3     | Named routes + `Navigator.push` / `pushNamed` / `pop` |
| 6   | BottomNavigationBar             | 2     | Home · Registration · Profile |
| 7   | TabBar and TabBarView           | 3     | Examination Instructions + Examination Questions |
| 8   | Form Validation and Submission  | 2     | Registration validators, clearance checks, exam submit confirmation |

---

## Eligibility Decision Logic

| School Feeding | Library     | Admin Verified | Result                |
|----------------|-------------|----------------|-----------------------|
| Cleared        | Cleared     | Yes            | **Eligible**          |
| Not cleared    | Any         | —              | **Not Eligible**      |
| Any            | Not cleared | —              | **Not Eligible**      |
| Any            | Any         | No             | **Pending Verification** |

> Students **cannot** self-approve eligibility. The “Verified by Administration” switch simulates the admin review required by the assessment rules.

---

## Demo Flow (for trainer)

1. Open app → **Home** shows college logo + title.  
2. Go to **Registration** (bottom nav or button) → fill form → submit.  
3. On **Eligibility** page → tick both clearances → toggle **Admin Verified**.  
4. Status becomes **Eligible** → “Proceed to Examination”.  
5. **Examination** page has two tabs: Instructions & Questions.  
6. Answer all questions → **Submit** → confirmation dialog with score.  
7. **Profile** page shows all student details and status.

---

## Sample Data Suggestions

- **Full Name:** Jean Baptiste Niyonzima  
- **Reg No:** APPEC/SD/2025/042  
- **Trade:** Software Development  
- **Level:** RTQF Level 5  
- **Gender:** Male  
- **Contact:** 0788123456  

---

*Developed for the Flutter Practical Assessment – College APPEC Remera-Rukoma TSS*
