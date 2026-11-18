class BoardAgreement {
  final String id;
  String title;
  String category; // e.g., 'Agreement', 'Policy / Rule', 'Meeting Agenda', 'Resolution'
  String details;
  DateTime dateAgreed;
  DateTime dateCreated;
  DateTime dateModified;

  BoardAgreement({
    required this.id,
    required this.title,
    this.category = 'Agreement',
    required this.details,
    required this.dateAgreed,
    DateTime? dateCreated,
    DateTime? dateModified,
  })  : dateCreated = dateCreated ?? DateTime.now(),
        dateModified = dateModified ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'details': details,
        'dateAgreed': dateAgreed.toIso8601String(),
        'dateCreated': dateCreated.toIso8601String(),
        'dateModified': dateModified.toIso8601String(),
      };

  factory BoardAgreement.fromJson(Map<String, dynamic> json) => BoardAgreement(
        id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: json['title'] ?? '',
        category: json['category'] ?? 'Agreement',
        details: json['details'] ?? '',
        dateAgreed: json['dateAgreed'] != null
            ? DateTime.parse(json['dateAgreed'])
            : DateTime.now(),
        dateCreated: json['dateCreated'] != null
            ? DateTime.parse(json['dateCreated'])
            : DateTime.now(),
        dateModified: json['dateModified'] != null
            ? DateTime.parse(json['dateModified'])
            : DateTime.now(),
      );
}