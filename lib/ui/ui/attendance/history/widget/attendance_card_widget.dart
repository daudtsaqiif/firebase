import 'package:flutter/material.dart';

class AttendanceCardWidget extends StatelessWidget {
  const AttendanceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      margin: EdgeInsets.all(10),
      color: Colors.white,
      child: Padding(padding: EdgeInsets.all(8)),
    );
  }
}
