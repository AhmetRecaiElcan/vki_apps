import 'package:flutter/material.dart';
import './main.dart';

class HistoryItem {
  final double height;
  final double weight;
  final double bmi;
  final DateTime date;

  HistoryItem({
    required this.height,
    required this.weight,
    required this.bmi,
    required this.date,
  });
}

class HistoryManager {
  static List<HistoryItem> _history = [];

  static List<HistoryItem> get history => _history;

  static void addHistory(double height, double weight, double bmi) {
    _history.add(HistoryItem(
      height: height,
      weight: weight,
      bmi: bmi,
      date: DateTime.now(),
    ));
  }

  static void clearHistory() {
    _history.clear();
  }
}
