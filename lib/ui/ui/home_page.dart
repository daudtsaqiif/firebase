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

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  welcomeText,
                  style: welcomeTextStyle,
                ),
                Text(
                  "Email: ${snapshot.data!['email']}",
                  style: subWelcomeTextStyle.copyWith(fontSize: 16),
                ),
                Text(
                  'name: ${snapshot.data!['first_name']}',
                  style: subWelcomeTextStyle,
                ),
                Text(
                  'uid: $userId',
                  style: subWelcomeTextStyle,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {},
                      child: Text(
                        'Attedance',
                        style: TextStyle(color: colorWhite),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                      ),
                      onPressed: () {},
                      child: Text(
                        'Notes',
                        style: TextStyle(color: colorWhite),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {},
                      child: Text(
                        'Profile',
                        style: TextStyle(color: colorWhite),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    _signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      color: colorWhite,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
