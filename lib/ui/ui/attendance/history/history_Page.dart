part of '../../../pages.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final dataService = DataServiceHistoryAttendance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('History Attendance'),
        ),
        body: StreamBuilder(
          stream: dataService.getAttendanceStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error Loading data'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No data available'));
            }

            final data = snapshot.data!.docs;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return AttendanceCardWidget(
                  data: data[index].data() as Map<String, dynamic>,
                  attendanceId: data[index].id,
                );
              },
            );
          },
        ));
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
    return getUserAttendance()
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
