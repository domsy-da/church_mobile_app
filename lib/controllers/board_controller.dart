import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/board_agreement_model.dart';

class BoardController extends ChangeNotifier {
  List<BoardAgreement> _agreements = [];
  String _adminPasskey = "Doms123Admin";

  List<BoardAgreement> get agreements => _agreements;

  BoardController() {
    loadData();
  }

  // --- STORAGE ---

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('board_agreements');
    if (jsonStr != null) {
      final List decoded = jsonDecode(jsonStr);
      _agreements = decoded.map((e) => BoardAgreement.fromJson(e)).toList();
    }
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_agreements.map((a) => a.toJson()).toList());
    await prefs.setString('board_agreements', encoded);
    notifyListeners();
  }

  // --- PASSKEY AUTHENTICATION ---

  bool verifyPasskey(String input) {
    return input.trim() == _adminPasskey;
  }

  void updatePasskey(String newPasskey) {
    if (newPasskey.isNotEmpty) {
      _adminPasskey = newPasskey.trim();
    }
  }

  // --- CRUD OPERATIONS ---

  void addAgreement(BoardAgreement item) {
    _agreements.insert(0, item); // newest first
    _saveData();
  }

  void updateAgreement(String id, BoardAgreement updated) {
    final index = _agreements.indexWhere((a) => a.id == id);
    if (index != -1) {
      updated.dateModified = DateTime.now();
      _agreements[index] = updated;
      _saveData();
    }
  }

  void deleteAgreement(String id) {
    _agreements.removeWhere((a) => a.id == id);
    _saveData();
  }

  // --- JSON IMPORT / EXPORT ---

  String exportToJson() {
    final rawList = _agreements.map((a) => a.toJson()).toList();
    return const JsonEncoder.withIndent('  ').convert(rawList);
  }

  bool importFromJson(String jsonString, {bool overwrite = false}) {
    try {
      final List rawList = jsonDecode(jsonString);
      if (overwrite) _agreements.clear();

      for (var item in rawList) {
        if (item is Map<String, dynamic>) {
          _agreements.add(BoardAgreement.fromJson(item));
        }
      }
      _saveData();
      return true;
    } catch (_) {
      return false;
    }
  }
}