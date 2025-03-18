part of '../../../pages.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  final dataService = DataServiceHistoryAttendance();
  late TabController _tabController;
  final List<String> _statusList = ['All', 'Late', 'Sick', 'Permission'];
  String selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusList.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedStatus = _statusList[_tabController.index];
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Attendance'),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: _statusList.map((status) => Tab(text: status)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _statusList.map((status) {
          return StreamBuilder(
            stream: dataService.getAttendanceStream(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error loading data'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No data available'));
              }

              // Filter data sesuai tab yang dipilih
              final data = snapshot.data!.docs.where((doc) {
                final docData = doc.data() as Map<String, dynamic>;
                final statusValue = docData['description'] ?? '';
                return status == 'All' || statusValue == status;
              }).toList();

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
          );
        }).toList(),
      ),
    );
  }
}

class DataServiceHistoryAttendance {
  final auth = FirebaseAuth.instance;

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
