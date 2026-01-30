import 'package:flutter/material.dart';

import '../models/medication.dart';
import '../theme/app_theme.dart';

class AppState extends ChangeNotifier {
  AppState._();

  static final AppState instance = AppState._();

  String name = '';
  IconData avatarIcon = Icons.person;
  Color avatarColor = kPrimary;
  final List<Medication> medications = [];

  void setProfile({required String name}) {
    this.name = name;
    notifyListeners();
  }

  void setAvatar({required IconData icon, required Color color}) {
    avatarIcon = icon;
    avatarColor = color;
    notifyListeners();
  }

  void addMedication(Medication medication) {
    medications.add(medication);
    notifyListeners();
  }

  void removeMedication(int index) {
    medications.removeAt(index);
    notifyListeners();
  }

  List<Medication> scheduleFor(DateTime date) {
    return medications.where((m) => m.isDueOn(date)).toList();
  }
}
