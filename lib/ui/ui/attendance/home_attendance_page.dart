part of '../../pages.dart';

class HomeAttendancePage extends StatefulWidget {
  const HomeAttendancePage({super.key});

  @override
  State<HomeAttendancePage> createState() => _HomeAttendancePageState();
}

class _HomeAttendancePageState extends State<HomeAttendancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Attendance'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/attendance');
              },
              child: Text('Chek In'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/leave');
              },
              child: Text('Leave Request'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/history');
              },
              child: Text('History'),
            ),
          ],
        ),
      ),
    );
  }
}
