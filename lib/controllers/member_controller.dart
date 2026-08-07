import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/member_model.dart';

class MemberController extends ChangeNotifier {
  List<Member> members = [];
  Map<String, AttendanceRecord> attendanceHistory = {}; // Keyed by YYYY-MM-DD

  MemberController() {
    loadData();
  }

  // --- PERSISTENCE (LOCAL STORAGE) ---

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Members
    final membersJson = prefs.getString('church_members');
    if (membersJson != null) {
      final List decoded = jsonDecode(membersJson);
      members = decoded.map((e) => Member.fromJson(e)).toList();
    }

    // Load Attendance
    final attendanceJson = prefs.getString('church_attendance');
    if (attendanceJson != null) {
      final Map<String, dynamic> decoded = jsonDecode(attendanceJson);
      attendanceHistory = decoded.map(
        (key, value) => MapEntry(key, AttendanceRecord.fromJson(value)),
      );
    }
    notifyListeners();
  }

  Future<void> _saveMembers() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(members.map((m) => m.toJson()).toList());
    await prefs.setString('church_members', encoded);
    notifyListeners();
  }

  Future<void> _saveAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      attendanceHistory.map((k, v) => MapEntry(k, v.toJson())),
    );
    await prefs.setString('church_attendance', encoded);
    notifyListeners();
  }

  // --- MEMBER CRUD OPERATIONS ---

  void addMember(Member member) {
    members.add(member);
    _saveMembers();
  }

  void updateMember(String id, Member updatedMember) {
    final index = members.indexWhere((m) => m.id == id);
    if (index != -1) {
      updatedMember.dateModified = DateTime.now();
      members[index] = updatedMember;
      _saveMembers();
    }
  }

  void deleteMember(String id) {
    members.removeWhere((m) => m.id == id);
    _saveMembers();
  }

  // --- JSON IMPORT / EXPORT ---

  /// Converts current members list to a formatted JSON string for export
  String exportToJson() {
    final List<Map<String, dynamic>> rawList =
        members.map((m) => m.toJson()).toList();
    return const JsonEncoder.withIndent('  ').convert(rawList);
  }

  /// Imports members from a JSON string.
  /// If [overwrite] is true, it replaces existing data; otherwise, it appends.
  bool importFromJson(String jsonString, {bool overwrite = false}) {
    try {
      final List<dynamic> rawList = jsonDecode(jsonString);
      if (overwrite) members.clear();

      for (var item in rawList) {
        if (item is Map<String, dynamic>) {
          members.add(Member.fromJson(item));
        }
      }
      _saveMembers();
      return true;
    } catch (e) {
      return false; // Returns false if JSON parsing fails
    }
  }

  // --- ATTENDANCE TRACKING ---

  void toggleAttendance(String date, String memberId) {
    final currentRecord = attendanceHistory[date]?.presentMemberIds ?? [];
    List<String> updatedList = List.from(currentRecord);

    if (updatedList.contains(memberId)) {
      updatedList.remove(memberId);
    } else {
      updatedList.add(memberId);
    }

    attendanceHistory[date] = AttendanceRecord(
      date: date,
      presentMemberIds: updatedList,
    );
    _saveAttendance();
  }

  bool isPresent(String date, String memberId) {
    return attendanceHistory[date]?.presentMemberIds.contains(memberId) ?? false;
  }

  int getPresentCount(String date) {
    return attendanceHistory[date]?.presentMemberIds.length ?? 0;
  }
}