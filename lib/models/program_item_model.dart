class ProgramItem {
  final String id;
  final String section;
  String title;
  String person;
  String event;
  bool isHymn;
  bool hasVP;
  String? tagalogVideoUrl;
  String? englishVideoUrl;

  ProgramItem({
    required this.id,
    required this.section,
    required this.title,
    this.person = '',
    this.event = '',
    this.isHymn = false,
    this.hasVP = false,
    this.tagalogVideoUrl,
    this.englishVideoUrl,
  });

  // ADD THIS COPYWITH METHOD
  ProgramItem copyWith({
    String? id,
    String? section,
    String? title,
    String? person,
    String? event,
    bool? isHymn,
    bool? hasVP,
    String? tagalogVideoUrl,
    String? englishVideoUrl,
  }) {
    return ProgramItem(
      id: id ?? this.id,
      section: section ?? this.section,
      title: title ?? this.title,
      person: person ?? this.person,
      event: event ?? this.event,
      isHymn: isHymn ?? this.isHymn,
      hasVP: hasVP ?? this.hasVP,
      tagalogVideoUrl: tagalogVideoUrl ?? this.tagalogVideoUrl,
      englishVideoUrl: englishVideoUrl ?? this.englishVideoUrl,
    );
  }

  // JSON CONVERTERS FOR LOCAL STORAGE
  Map<String, dynamic> toJson() => {
        'id': id,
        'section': section,
        'title': title,
        'person': person,
        'event': event,
        'isHymn': isHymn,
        'hasVP': hasVP,
        'tagalogVideoUrl': tagalogVideoUrl,
        'englishVideoUrl': englishVideoUrl,
      };

  factory ProgramItem.fromJson(Map<String, dynamic> json) => ProgramItem(
        id: json['id'],
        section: json['section'],
        title: json['title'],
        person: json['person'] ?? '',
        event: json['event'] ?? '',
        isHymn: json['isHymn'] ?? false,
        hasVP: json['hasVP'] ?? false,
        tagalogVideoUrl: json['tagalogVideoUrl'],
        englishVideoUrl: json['englishVideoUrl'],
      );
}