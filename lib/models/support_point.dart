class SupportPoint {
  final String name;
  final String type;
  final String phoneNumber;
  final String address;
  final double latitude;  // YENİ
  final double longitude; // YENİ

  SupportPoint({
    required this.name,
    required this.type,
    required this.phoneNumber,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}