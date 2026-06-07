class ProduceListing {
  final String id;
  final String farmerId;
  final String cropName;
  final String description;
  final double quantity;
  final String unit;
  final double? price;
  final String? pricePerUnit;
  final String location;
  final String district;
  final String region;
  final DateTime harvestDate;
  final String status;
  final String quality;
  final List<String> images;
  final List<String>? certifications;
  final int views;
  final int contacted;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProduceListing({
    required this.id,
    required this.farmerId,
    required this.cropName,
    required this.description,
    required this.quantity,
    required this.unit,
    this.price,
    this.pricePerUnit,
    required this.location,
    required this.district,
    required this.region,
    required this.harvestDate,
    required this.status,
    required this.quality,
    required this.images,
    this.certifications,
    required this.views,
    required this.contacted,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'farmerId': farmerId,
    'cropName': cropName,
    'description': description,
    'quantity': quantity,
    'unit': unit,
    'price': price,
    'pricePerUnit': pricePerUnit,
    'location': location,
    'district': district,
    'region': region,
    'harvestDate': harvestDate,
    'status': status,
    'quality': quality,
    'images': images,
    'certifications': certifications,
    'views': views,
    'contacted': contacted,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  factory ProduceListing.fromJson(Map<String, dynamic> json) => ProduceListing(
    id: json['id'],
    farmerId: json['farmerId'],
    cropName: json['cropName'],
    description: json['description'] ?? '',
    quantity: (json['quantity'] as num).toDouble(),
    unit: json['unit'],
    price: json['price'] != null ? (json['price'] as num).toDouble() : null,
    pricePerUnit: json['pricePerUnit'],
    location: json['location'],
    district: json['district'],
    region: json['region'],
    harvestDate: json['harvestDate']?.toDate() ?? DateTime.now(),
    status: json['status'],
    quality: json['quality'] ?? 'standard',
    images: List<String>.from(json['images'] ?? []),
    certifications: json['certifications'] != null 
      ? List<String>.from(json['certifications']) 
      : null,
    views: json['views'] ?? 0,
    contacted: json['contacted'] ?? 0,
    createdAt: json['createdAt']?.toDate() ?? DateTime.now(),
    updatedAt: json['updatedAt']?.toDate() ?? DateTime.now(),
  );
}
