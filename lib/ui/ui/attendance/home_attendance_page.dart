part of '../../pages.dart';

class HomeAttendancePage extends StatefulWidget {
  const HomeAttendancePage({super.key});

  @override
  State<HomeAttendancePage> createState() => _HomeAttendancePageState();
}

class _HomeAttendancePageState extends State<HomeAttendancePage> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String date = DateFormat('EEEE, d MMMM yyyy').format(now);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/face.png')
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hello, Students👋",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "$date",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Grid Section
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/attendance');
                    },
                    child: attendanceCard("Check In", "07:30 - 07:45 am",
                        Icons.login, Colors.green.shade100),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/attendance');
                    },
                    child: attendanceCard("Check Out", "03:45 - 04:00 pm",
                        Icons.logout, Colors.pink.shade100),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/leave');
                    },
                    child: attendanceCard(
                      "Permition",
                      "08:00 am",
                      Icons.logout,
                      Colors.pink.shade100,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/history');
                    },
                    child: attendanceCard(
                      "History",
                      "-",
                      Icons.access_time,
                      Colors.orange.shade100,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget attendanceCard(
  String title,
  String time,
  IconData icon,
  Color bgColor,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: bgColor,
          child: Icon(icon, color: Colors.black, size: 23),
        ),
        const SizedBox(height: 10),
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 5),
        Text(
          time,
          style: const TextStyle(
              fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 5),
      ],
    ),
  );
}
