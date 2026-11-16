class Student {
  final String fullName;
  final String registrationNumber;
  final String trade;
  final String level;
  final String gender;
  final String contact;
  final bool schoolFeedingCleared;
  final bool libraryCleared;
  final bool isAdminVerified;
  final String eligibilityStatus; // Eligible, Not Eligible, Pending Verification

  Student({
    required this.fullName,
    required this.registrationNumber,
    required this.trade,
    required this.level,
    required this.gender,
    required this.contact,
    required this.schoolFeedingCleared,
    required this.libraryCleared,
    this.isAdminVerified = false,
    required this.eligibilityStatus,
  });

  Student copyWith({
    String? fullName,
    String? registrationNumber,
    String? trade,
    String? level,
    String? gender,
    String? contact,
    bool? schoolFeedingCleared,
    bool? libraryCleared,
    bool? isAdminVerified,
    String? eligibilityStatus,
  }) {
    return Student(
      fullName: fullName ?? this.fullName,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      trade: trade ?? this.trade,
      level: level ?? this.level,
      gender: gender ?? this.gender,
      contact: contact ?? this.contact,
      schoolFeedingCleared: schoolFeedingCleared ?? this.schoolFeedingCleared,
      libraryCleared: libraryCleared ?? this.libraryCleared,
      isAdminVerified: isAdminVerified ?? this.isAdminVerified,
      eligibilityStatus: eligibilityStatus ?? this.eligibilityStatus,
    );
  }

  /// Decision logic from the assessment:
  /// - Both cleared + admin verified → Eligible
  /// - Any not cleared → Not Eligible
  /// - Unknown / not yet verified by admin → Pending Verification
  static String calculateEligibility({
    required bool schoolFeedingCleared,
    required bool libraryCleared,
    required bool isAdminVerified,
  }) {
    if (!isAdminVerified) {
      return 'Pending Verification';
    }
    if (schoolFeedingCleared && libraryCleared) {
      return 'Eligible';
    }
    return 'Not Eligible';
  }
}
