class LeaveRequest {
  final String id;
  final String employeeId;
  final String type;
  late final String status;
  final DateTime timestamp;

  LeaveRequest({
    required this.id,
    required this.employeeId,
    required this.type,
    this.status = 'pending',
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'type': type,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory LeaveRequest.fromMap(Map<String, dynamic> map) {
    return LeaveRequest(
      id: map['id'],
      employeeId: map['employeeId'],
      type: map['type'],
      status: map['status'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
