/// สาขาของร้าน (ข้อมูลจากเซิร์ฟเวอร์ สัปดาห์ 11 ใช้หาสาขาใกล้สุดในสัปดาห์ 13)
class Branch {
  const Branch({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.hours = '',
  });

  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String hours;

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    id: json['id'] as String,
    name: json['name'] as String,
    latitude: (json['lat'] as num).toDouble(),
    longitude: (json['lng'] as num).toDouble(),
    hours: json['hours'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'lat': latitude,
    'lng': longitude,
    'hours': hours,
  };
}

/// สาขาตัวอย่าง (พิกัดโดยประมาณในเชียงใหม่)
const List<Branch> sampleBranches = [
  Branch(
    id: 'eng',
    name: 'สาขาคณะวิศวกรรมศาสตร์',
    latitude: 18.8064,
    longitude: 98.9530,
    hours: '07:30–17:00',
  ),
  Branch(
    id: 'library',
    name: 'สาขาหอสมุด',
    latitude: 18.8080,
    longitude: 98.9555,
    hours: '08:00–20:00',
  ),
  Branch(
    id: 'dorm',
    name: 'สาขาหอพักนักศึกษา',
    latitude: 18.8031,
    longitude: 98.9512,
    hours: '06:30–22:00',
  ),
];
