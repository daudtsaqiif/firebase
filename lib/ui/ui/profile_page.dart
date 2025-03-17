part of '../pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseService _auth = FirebaseService();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool isLoading = false;
  String? profileImage;
  File? imageFile;

  @override
  void initState() {
    _loadProfileData();
    _checkEmailVerified();
    super.initState();
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

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? _pickedimage =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (_pickedimage != null) {
      setState(() {
        imageFile = File(_pickedimage.path);
      });
    }

    if (imageFile != null) {
      _uploadImage(imageFile!);
    }
  }

//upload image to firebase
  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      isLoading = true;
    });
    String userId = FirebaseAuth.instance.currentUser!.uid;

    Reference reference =
        FirebaseStorage.instance.ref().child('profileImage/$userId');

    UploadTask uploadTask = reference.putFile(imageFile);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    await _auth.uploadProfileImage(imageUrl);

    setState(() {
      profileImage = imageUrl;
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text('Image upload successfully'),
      ),
    );
  }

  void _loadProfileData() async {
    User? user = _auth.currentUser;
    String userId = user!.uid;
    Map<String, dynamic> userData = await _auth.getUserData(userId);

    _firstNameController.text = userData['first_name'];
    _lastNameController.text = userData['last_name'];
  }

  void updateProfile() async {
    setState(() {
      isLoading = true;
    });
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;

    await _auth.updateProfile(firstName, lastName);

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
      body: Column(
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
                  backgroundImage: AssetImage('assets/avatar.png'),
                ),
                SizedBox(height: 10),
                Text(
                  "name:",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Role: ",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
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
                    Icons.lock_person_rounded,
                    "Forgot Password",
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget ProfileOption(IconData icon, String title, IconData icon2) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          SizedBox(width: 10),
          Text(title, style: TextStyle(fontSize: 16)),
          Spacer(),
          Icon(icon2, color: Colors.blueAccent, size: 30),
        ]));
  }
}
