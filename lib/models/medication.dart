import 'package:flutter/material.dart';

enum MedicationFrequency {
  daily,
  weekly,
  monthly,
  custom,
}

class Medication {
  final String name;
  final MedicationFrequency frequency;
  final List<int> weekdays;
  final int? dayOfMonth;
  final TimeOfDay? time;

  const Medication({
    required this.name,
    required this.frequency,
    this.weekdays = const [],
    this.dayOfMonth,
    this.time,
  });

  bool isDueOn(DateTime date) {
    switch (frequency) {
      case MedicationFrequency.daily:
        return true;
      case MedicationFrequency.weekly:
      case MedicationFrequency.custom:
        return weekdays.contains(date.weekday);
      case MedicationFrequency.monthly:
        return dayOfMonth == date.day;
    }
  }
}
