part of '../pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userId;
  late Future<Map<String, dynamic>> userData;

  final FirebaseService _auth = FirebaseService();

  @override
  void initState() {
    super.initState();

    User? user = _auth.currentUser;

    userId = user!.uid;
    userData = _auth.getUserData(userId!);
  }

  void _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('User data not found'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            NetworkImage('https://i.pravatar.cc/150?img=3'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${snapshot.data!['first_name']} ${snapshot.data!['last_name']}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Student Of IDN BOARDING SCHOOL",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _signOut,
                        icon: const Icon(Icons.logout),
                        color: Colors.red,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Text('WELCOME TO STUDENT PORTAL',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white)),
                        const SizedBox(height: 5),
                        Text(
                          'IDN BOARDING SCHOOL',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/home-attendance');
                              },
                              child: homeCard('Absen', 'Lakukan Absensi',
                                  Icons.camera_alt_outlined, Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/note');
                              },
                              child: homeCard('Catatan', 'Catananku',
                                  Icons.book_outlined, Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/profile');
                          },
                          child: homeCard('Profile', 'Cek Profile',
                              Icons.person_2_outlined, Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Text(
                        'Visi',
                        style: welcomeTextStyle,
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Menjadi pusat unggulan dalam menciptakan generasi ahli di bidang Teknologi Informasi (IT) melalui lingkungan “Expert Factory,” di mana kolaborasi dan inovasi menjadi dasar pengembangan kompetensi siswa. Kami berkomitmen untuk membentuk individu berbakat yang tidak hanya menguasai teknologi, tetapi juga memiliki kemampuan untuk menghasilkan solusi inovatif yang berdampak global.',
                          style: judulTextStyle,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Text(
                        'Misi',
                        style: welcomeTextStyle,
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Mencetak tenaga profesional di bidang IT yang mampu bersaing di tingkat global, sekaligus membentuk kader dakwah yang berlandaskan Al-Qur’an dan Sunnah. Kami berfokus pada pengembangan potensi setiap siswa melalui pendekatan pendidikan berbasis teknologi dan nilai-nilai Islam. Selain itu, kami menjalin kemitraan erat dengan orang tua dalam mendukung perkembangan akademik dan spiritual siswa, menciptakan generasi yang berkarakter Islami dan berdaya saing tinggi.',
                          style: judulTextStyle,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget homeCard(
    String title,
    String description,
    IconData icon,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: 200,
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
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
