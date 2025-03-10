part of '../../../pages.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}

class DataServiceHistoryAttendance {
  final auth = FirebaseAuth.instance;

  //get id attendance users

  CollectionReference getUserAttendance() {
    final String? userId = auth.currentUser?.uid;
    if (userId == null) {
      throw Exception("User is not logged in");
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('attendance');
  }

  Stream<QuerySnapshot> getAttendanceStream() {
    return getUserAttendance().orderBy('createdAt', descending: true).snapshots();
  }
}
