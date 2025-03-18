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
        title: const Text('Attendance Home',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                children: [
                  const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/face.png')),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hello, Students👋",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
              Column(
                children: [
                  // Baris Pertama
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/attendance');
                          },
                          child: attendanceCard("Check In", "07:30 - 07:45 am",
                              Icons.login, Colors.green.shade100),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/attendance');
                          },
                          child: attendanceCard("Check Out", "03:45 - 04:00 pm",
                              Icons.logout, Colors.pink.shade100),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Baris Kedua
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/permittion');
                          },
                          child: attendanceCard("Permission", "08:00 am",
                              Icons.logout, Colors.purple.shade100),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/history');
                          },
                          child: attendanceCard("History", "-",
                              Icons.access_time, Colors.orange.shade100),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NOTE:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '1. Absensi dimulai dari jam 07:30 sampai jam 07:50 am.',
                    style: subWelcomeTextStyle.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '2. Pada saat melakukan absen siswa harus berada dalam lingkungan sekolah.',
                    style: subWelcomeTextStyle.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '3. Jika siswa terlambat melakukan absen maka akan terkena sanksi berupa pengurangan point.',
                    style: subWelcomeTextStyle.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '4. Jika siswa absen di luar zona sekolah maka akan terkena sanksi berupa pengurangan point.',
                    style: subWelcomeTextStyle.copyWith(color: Colors.black),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Alert note
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Jika terdapat kendala, silakan hubungi pihak admin.",
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 5),
      ],
    ),
  );
}
