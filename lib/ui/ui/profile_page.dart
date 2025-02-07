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
    if (!user!.emailVerified) {
      await user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Email verification link has been sent!'),
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
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  _pickImage();
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: imageFile != null
                          ? FileImage(imageFile!)
                          : profileImage != null
                              ? NetworkImage(profileImage!)
                              : const AssetImage("assets/images/mulogo.png"),
                    ),
                    Positioned(
                      child: Icon(
                        Icons.camera_alt,
                      ),
                      bottom: 0,
                      right: 0,
                    ),
                  ],
                ),
              ),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
              const SizedBox(height: 10),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        updateProfile();
                      },
                      child: const Text('Save'),
                    ),
              const SizedBox(height: 10),
              (FirebaseAuth.instance.currentUser!.emailVerified)
                  ? const Text('Email verified')
                  : ElevatedButton(
                      onPressed: () {
                        _sendEmailVerification();
                      },
                      child: const Text('Send Email Verification'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
