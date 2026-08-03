class ProgramItem {
  final String id;
  final String section;
  final String title;
  String person;
  String event;
  final bool isHymn;
  final bool hasVP;
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

  ProgramItem copyWith({
    String? person,
    String? event,
    String? tagalogVideoUrl,
    String? englishVideoUrl,
  }) {
    return ProgramItem(
      id: id,
      section: section,
      title: title,
      person: person ?? this.person,
      event: event ?? this.event,
      isHymn: isHymn,
      hasVP: hasVP,
      tagalogVideoUrl: tagalogVideoUrl ?? this.tagalogVideoUrl,
      englishVideoUrl: englishVideoUrl ?? this.englishVideoUrl,
    );
  }
}