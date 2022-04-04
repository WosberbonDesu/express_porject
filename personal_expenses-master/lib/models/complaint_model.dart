// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Complaint {
  String complaint;
  Timestamp complaintDate;
  String userName;
  String userId;
  Complaint({
    required this.complaint,
    required this.complaintDate,
    required this.userName,
    required this.userId,
  });

  Complaint copyWith({
    String? complaint,
    Timestamp? complaintDate,
    String? userName,
    String? userId,
  }) {
    return Complaint(
      complaint: complaint ?? this.complaint,
      complaintDate: complaintDate ?? this.complaintDate,
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'complaint': complaint,
      'complaintDate': complaintDate,
      'userName': userName,
      'userId': userId,
    };
  }

  factory Complaint.fromMap(Map<String, dynamic> map) {
    return Complaint(
      complaint: map['complaint'] ?? '',
      complaintDate: map['complaintDate'],
      userName: map['userName'] ?? '',
      userId: map['userId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Complaint.fromJson(String source) =>
      Complaint.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Complaint(complaint: $complaint, complaintDate: $complaintDate, userName: $userName, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Complaint &&
        other.complaint == complaint &&
        other.complaintDate == complaintDate &&
        other.userName == userName &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return complaint.hashCode ^
        complaintDate.hashCode ^
        userName.hashCode ^
        userId.hashCode;
  }
}
