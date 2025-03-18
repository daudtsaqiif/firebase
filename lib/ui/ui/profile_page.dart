part of '../pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userId;
  late Future<Map<String, dynamic>> userData;
  final FirebaseService _auth = FirebaseService();

  bool isLoading = false;

  void initState() {
    _checkEmailVerified();
    super.initState();

    User? user = _auth.currentUser;

    userId = user!.uid;
    userData = _auth.getUserData(userId!);
  }

  //cek email verified
  void _checkEmailVerified() async {
    setState(() {
      isLoading = true;
    });

    User? user = _auth.currentUser;
    if (user!.emailVerified) {
      await user.reload();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Email has been verified!'),
        ),
      );
    } else {
      await user.reload();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please verify your email!'),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  void _sendEmailVerification() async {
    setState(() {
      isLoading = true;
    });
    User? user = _auth.currentUser;
    await user!.sendEmailVerification();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Email verification link has been sent!'),
      ),
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          title: Text("Profile", style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: FutureBuilder(
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
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/face.png'),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Name: ${snapshot.data!['first_name']} ${snapshot.data!['last_name']}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Role: ${snapshot.data!['role']}",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/update-profile');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text("Edit Profile",
                              style: TextStyle(color: Colors.blueAccent)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(20),
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/change-password');
                          },
                          child: ProfileOption(
                            Icons.lock,
                            "Change Password",
                            Icons.navigate_next,
                          ),
                        ),
                        Divider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/change-password');
                          },
                          child: ProfileOption(
                            Icons.handyman_rounded,
                            "Privacy & Policy",
                            Icons.navigate_next,
                          ),
                        ),
                        Divider(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/change-password');
                          },
                          child: ProfileOption(
                            Icons.settings,
                            "Settings",
                            Icons.navigate_next,
                          ),
                        ),
                        Divider(),
                        SizedBox(height: 10),
                        StreamBuilder<QuerySnapshot>(
                          stream: DataServiceHistoryAttendance()
                              .getAttendanceStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: _cardCount(
                                      'Attendance',
                                      '0',
                                      Icons.work_history_outlined,
                                      Colors.green,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: _cardCount(
                                      'Late',
                                      '0',
                                      Icons.access_time,
                                      Colors.orange,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: _cardCount(
                                      'Permission',
                                      '0',
                                      Icons.event_available,
                                      Colors.blue,
                                    ),
                                  ),
                                ],
                              );
                            }
                            // Hitung jumlah masing-masing kategori
                            int attendanceCount = 0;
                            int lateCount = 0;
                            int permissionCount = 0;

                            for (var doc in snapshot.data!.docs) {
                              String description = doc['description'];
                              if (description == 'Attendance') {
                                attendanceCount++;
                              } else if (description == 'Late') {
                                lateCount++;
                              } else if (description == 'Permission') {
                                permissionCount++;
                              }
                            }

                            return Row(
                              children: [
                                Expanded(
                                  child: _cardCount(
                                    'Attendance',
                                    '$attendanceCount',
                                    Icons.work_history_outlined,
                                    Colors.green,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: _cardCount(
                                    'Late',
                                    '$lateCount',
                                    Icons.access_time,
                                    Colors.orange,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: _cardCount(
                                    'Permission',
                                    '$permissionCount',
                                    Icons.event_available,
                                    Colors.blue,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }));
  }

  Widget _cardCount(String title, String count, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.3),
            child: Icon(icon, color: Colors.white),
          ),
          Text(
            title,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            count,
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget ProfileOption(IconData icon, String title, IconData icon2) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          SizedBox(width: 10),
          Text(title, style: TextStyle(fontSize: 16)),
          Spacer(),
          Icon(icon2, color: Colors.blueAccent, size: 30),
        ],
      ),
    );
  }
}
