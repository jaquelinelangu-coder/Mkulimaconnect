import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String phone;
  final String name;
  final String userType; // 'farmer' or 'buyer'
  final String region;
  final String district;
  final bool isVerified;
  final DateTime createdAt;
  
  // Farmer-specific fields
  final String? farmName;
  final List<String>? cropSpecialties;

  User({
    required this.id,
    required this.phone,
    required this.name,
    required this.userType,
    required this.region,
    required this.district,
    required this.isVerified,
    required this.createdAt,
    this.farmName,
    this.cropSpecialties,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'phone': phone,
    'name': name,
    'userType': userType,
    'region': region,
    'district': district,
    'isVerified': isVerified,
    'createdAt': createdAt,
    'farmName': farmName,
    'cropSpecialties': cropSpecialties,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    phone: json['phone'],
    name: json['name'],
    userType: json['userType'],
    region: json['region'],
    district: json['district'],
    isVerified: json['isVerified'] ?? false,
    createdAt: json['createdAt']?.toDate() ?? DateTime.now(),
    farmName: json['farmName'],
    cropSpecialties: List<String>.from(json['cropSpecialties'] ?? []),
  );
}
