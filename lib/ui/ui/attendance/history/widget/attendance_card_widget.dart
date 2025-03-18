import 'dart:math';

import 'package:flutter/material.dart';

class AttendanceCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final String attendanceId;

  const AttendanceCardWidget({
    super.key,
    required this.data,
    required this.attendanceId,
  });

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'late':
        return Colors.orange.shade100;
      case 'sick':
        return Colors.yellow.shade100;
      case 'permission':
        return Colors.blue.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color getBadgeColor(String status) {
    switch (status.toLowerCase()) {
      case 'late':
        return Colors.orange;
      case 'sick':
        return Colors.yellow;
      case 'permission':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: getStatusColor(data['description']),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['name'],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.access_time, size: 14),
              SizedBox(width: 5),
              Text(data['datetime']),
            ],
          ),
          Row(
            children: [
              Icon(Icons.location_on, size: 14),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  data['address'],
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: getBadgeColor(data['description']),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              data['description'],
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
