import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'transaction_model.dart';

class UserModel {
  String uid;
  String name;
  String email;
  num phoneNumber;
  List<String> deviceList;
  Timestamp createdAt;
  Timestamp lastLogin;
  String? imageURL;
  num currentBudget;
  num notifyBudget;
  num monthlyIncome;
  num monthlyOutcome;
  List<TransactionModel>? transactions;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.deviceList,
    required this.createdAt,
    required this.lastLogin,
    this.imageURL,
    required this.currentBudget,
    required this.notifyBudget,
    required this.monthlyIncome,
    required this.monthlyOutcome,
    this.transactions,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    num? phoneNumber,
    List<String>? deviceList,
    Timestamp? createdAt,
    Timestamp? lastLogin,
    String? imageURL,
    num? currentBudget,
    num? notifyBudget,
    num? monthlyIncome,
    num? monthlyOutcome,
    List<TransactionModel>? transactions,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      deviceList: deviceList ?? this.deviceList,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      imageURL: imageURL ?? this.imageURL,
      currentBudget: currentBudget ?? this.currentBudget,
      notifyBudget: notifyBudget ?? this.notifyBudget,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyOutcome: monthlyOutcome ?? this.monthlyOutcome,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'deviceList': deviceList,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
      'imageURL': imageURL,
      'currentBudget': currentBudget,
      'notifyBudget': notifyBudget,
      'monthlyIncome': monthlyIncome,
      'monthlyOutcome': monthlyOutcome,
      'transactions': transactions?.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? 0,
      deviceList: List<String>.from(map['deviceList']),
      createdAt: map['createdAt'],
      lastLogin: map['lastLogin'],
      imageURL: map['imageURL'],
      currentBudget: map['currentBudget'] ?? 0,
      notifyBudget: map['notifyBudget'] ?? 0,
      monthlyIncome: map['monthlyIncome'] ?? 0,
      monthlyOutcome: map['monthlyOutcome'] ?? 0,
      transactions: map['transactions'] != null
          ? List<TransactionModel>.from(
              map['transactions']?.map((x) => TransactionModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, phoneNumber: $phoneNumber, deviceList: $deviceList, createdAt: $createdAt, lastLogin: $lastLogin, imageURL: $imageURL, currentBudget: $currentBudget, notifyBudget: $notifyBudget, monthlyIncome: $monthlyIncome, monthlyOutcome: $monthlyOutcome, transactions: $transactions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        listEquals(other.deviceList, deviceList) &&
        other.createdAt == createdAt &&
        other.lastLogin == lastLogin &&
        other.imageURL == imageURL &&
        other.currentBudget == currentBudget &&
        other.notifyBudget == notifyBudget &&
        other.monthlyIncome == monthlyIncome &&
        other.monthlyOutcome == monthlyOutcome &&
        listEquals(other.transactions, transactions);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        deviceList.hashCode ^
        createdAt.hashCode ^
        lastLogin.hashCode ^
        imageURL.hashCode ^
        currentBudget.hashCode ^
        notifyBudget.hashCode ^
        monthlyIncome.hashCode ^
        monthlyOutcome.hashCode ^
        transactions.hashCode;
  }
}
