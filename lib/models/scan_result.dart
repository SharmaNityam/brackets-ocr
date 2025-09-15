class ScanResult {
  final String id;
  final DateTime timestamp;
  final List<String> extractedNumbers;
  final String? imagePath;

  ScanResult({
    required this.id,
    required this.timestamp,
    required this.extractedNumbers,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'extractedNumbers':
          extractedNumbers.isEmpty ? '' : extractedNumbers.join(','),
      'imagePath': imagePath,
    };
  }

  factory ScanResult.fromMap(Map<String, dynamic> map) {
    final numbersString = map['extractedNumbers'].toString();
    final numbers =
        numbersString.isEmpty ? <String>[] : numbersString.split(',');

    return ScanResult(
      id: map['id'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      extractedNumbers: numbers.where((n) => n.isNotEmpty).toList(),
      imagePath: map['imagePath'],
    );
  }

  String get displayNumbers {
    if (extractedNumbers.isEmpty) return 'No numbers found';
    return extractedNumbers.take(3).join(', ') +
        (extractedNumbers.length > 3 ? '...' : '');
  }
}
