class LeaveRequest {
  final String id;
  final String employeeId; // Link to the employee making the request
  final String type; // e.g., "Vacation", "Sick Leave"
  late final String status; // e.g., "pending", "approved", "declined"
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