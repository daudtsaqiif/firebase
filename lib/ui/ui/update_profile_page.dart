part of '../pages.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final FirebaseService _auth = FirebaseService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool isLoading = false;
  String? profileImage = "";
  File? imageFile;

  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      isLoading = true;
    });
    String? userId = FirebaseAuth.instance.currentUser!.uid;
    Reference refrence =
        FirebaseStorage.instance.ref().child("profile/$userId");
    UploadTask uploadTask = refrence.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      profileImage = imageUrl;
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Profile image has been updated',
      ),
      backgroundColor: Colors.green,
    ));
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }

    if (imageFile != null) {
      _uploadImage(imageFile!);
    }
  }

  void _updateProfile() async {
    setState(() {
      isLoading = true;
    });
    String? name = _nameController.text;
    String? lastName = _lastNameController.text;

    await _auth.updateProfile(name, lastName);

    setState(() {
      isLoading = false;
    });
  }

  void _sendEmailVerification() async {
    setState(() {
      isLoading = true;
    });
    User? user = _auth.currentUser;
    await user?.sendEmailVerification();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Email verification has been sent',
      ),
      backgroundColor: Colors.green,
    ));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: Text(
            'Edit Profile',
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, // Memberikan warna putih
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: imageFile != null
                          ? FileImage(imageFile!)
                          : profileImage != null
                              ? NetworkImage(profileImage!) as ImageProvider
                              : const AssetImage('assets/images/berelang.jpeg'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Text('nama'),
                Text('email'),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Update Profile',
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _sendEmailVerification,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Send Email Verification',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
