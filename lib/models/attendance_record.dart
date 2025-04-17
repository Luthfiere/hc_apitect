class AttendanceRecord {
  final DateTime clockIn;
  final DateTime clockOut;
  final Duration workingDuration;

  AttendanceRecord({
    required this.clockIn,
    required this.clockOut,
    required this.workingDuration,
  });

  String get formattedClockIn =>
      "${clockIn.hour}:${clockIn.minute}:${clockIn.second}";
  String get formattedClockOut =>
      "${clockOut.hour}:${clockOut.minute}:${clockOut.second}";
  String get formattedDuration =>
      "${workingDuration.inHours}:${workingDuration.inMinutes.remainder(60)}:${workingDuration.inSeconds.remainder(60)}";
}
