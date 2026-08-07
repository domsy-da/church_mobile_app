class Member {
  final String id;
  String name;
  String phoneNumber;
  String address;
  String position;
  DateTime? birthDay;
  DateTime? baptismDate;
  String status; // e.g. Single, Married, Widowed, Separated
  String occupation; // e.g. Student, Employed, Self-Employed, Unemployed, Retired
  String spiritualTalent; // e.g. Praying, Singing, Preaching, Custom
  String shortSelfDescription;
  DateTime dateCreated;
  DateTime dateModified;
  bool isPresent;

  Member({
    required this.id,
    required this.name,
    this.phoneNumber = '',
    this.address = '',
    this.position = 'Member',
    this.birthDay,
    this.baptismDate,
    this.status = 'Single',
    this.occupation = 'Student',
    this.spiritualTalent = 'Praying',
    this.shortSelfDescription = '',
    DateTime? dateCreated,
    DateTime? dateModified,
    this.isPresent = false,
  })  : dateCreated = dateCreated ?? DateTime.now(),
        dateModified = dateModified ?? DateTime.now();

  // Computed getter: automatically calculates age from birthDay
  int get age {
    if (birthDay == null) return 0;
    final now = DateTime.now();
    int computedAge = now.year - birthDay!.year;
    if (now.month < birthDay!.month ||
        (now.month == birthDay!.month && now.day < birthDay!.day)) {
      computedAge--;
    }
    return computedAge;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phoneNumber': phoneNumber,
        'address': address,
        'position': position,
        'birthDay': birthDay?.toIso8601String(),
        'baptismDate': baptismDate?.toIso8601String(),
        'status': status,
        'occupation': occupation,
        'spiritualTalent': spiritualTalent,
        'shortSelfDescription': shortSelfDescription,
        'dateCreated': dateCreated.toIso8601String(),
        'dateModified': dateModified.toIso8601String(),
        'isPresent': isPresent,
      };

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: json['name'] ?? '',
        phoneNumber: json['phoneNumber'] ?? json['phone'] ?? '',
        address: json['address'] ?? '',
        position: json['position'] ?? json['role'] ?? 'Member',
        birthDay: json['birthDay'] != null ? DateTime.tryParse(json['birthDay']) : null,
        baptismDate: json['baptismDate'] != null ? DateTime.tryParse(json['baptismDate']) : null,
        status: json['status'] ?? 'Single',
        occupation: json['occupation'] ?? 'Student',
        spiritualTalent: json['spiritualTalent'] ?? 'Praying',
        shortSelfDescription: json['shortSelfDescription'] ?? '',
        dateCreated: json['dateCreated'] != null ? DateTime.parse(json['dateCreated']) : DateTime.now(),
        dateModified: json['dateModified'] != null ? DateTime.parse(json['dateModified']) : DateTime.now(),
        isPresent: json['isPresent'] ?? false,
      );
}

class AttendanceRecord {
  final String date; // Format: "YYYY-MM-DD"
  final List<String> presentMemberIds;

  AttendanceRecord({
    required this.date,
    required this.presentMemberIds,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'presentMemberIds': presentMemberIds,
      };

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) => AttendanceRecord(
        date: json['date'],
        presentMemberIds: List<String>.from(json['presentMemberIds'] ?? []),
      );
}