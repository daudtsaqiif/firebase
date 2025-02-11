part of '../pages.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final FirebaseService _auth = FirebaseService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool isObscureText = true;
  bool isLoading = false;
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController NewPasswordController = TextEditingController();
  TextEditingController ConfrimPasswordController = TextEditingController();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _changePassword() async {
    setState(() {
      isLoading = true;
    });

    String currentPassword = currentPasswordController.text.trim();
    String newPassword = NewPasswordController.text.trim();
    String confirmPassword = ConfrimPasswordController.text.trim();

    //check if field is emty
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnackBar("Please fill all the fields");
      setState(() {
        isLoading = false;
      });
      return;
    }

    //check if the new password and confrim password is not same
    if (newPassword != confirmPassword) {
      _showSnackBar("New password and confirm password is not same");
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      User? user = _firebaseAuth.currentUser;
      if (user == null) {
        _showSnackBar("User not found");
        setState(() {
          isLoading = false;
        });
        return;
      }

      //reauthnticate the user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      //old password cannot be the same as new password
      if (currentPassword == newPassword) {
        _showSnackBar("Old password cannot be the same as new password");
        setState(() {
          isLoading = false;
        });
        return;
      }
      await _auth.changePassword(newPassword);
      currentPasswordController.clear();
      NewPasswordController.clear();
      ConfrimPasswordController.clear();

      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/sign-in', (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password changed successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextFormField(
                controller: currentPasswordController,
                decoration: InputDecoration(
                  hintText: 'Current Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscureText = !isObscureText;
                      });
                    },
                    icon: isObscureText
                        ? Icon(
                            Icons.visibility_off_outlined,
                            color: colorPrimary,
                          )
                        : Icon(
                            Icons.visibility,
                            color: colorPrimary,
                          ),
                  ),
                ),
                obscureText: isObscureText ? true : false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextFormField(
                controller: NewPasswordController,
                decoration: InputDecoration(
                  hintText: 'New Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscureText = !isObscureText;
                      });
                    },
                    icon: isObscureText
                        ? Icon(
                            Icons.visibility_off_outlined,
                            color: colorPrimary,
                          )
                        : Icon(
                            Icons.visibility,
                            color: colorPrimary,
                          ),
                  ),
                ),
                obscureText: isObscureText ? true : false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextFormField(
                controller: ConfrimPasswordController,
                decoration: InputDecoration(
                  hintText: 'confrim password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObscureText = !isObscureText;
                      });
                    },
                    icon: isObscureText
                        ? Icon(
                            Icons.visibility_off_outlined,
                            color: colorPrimary,
                          )
                        : Icon(
                            Icons.visibility,
                            color: colorPrimary,
                          ),
                  ),
                ),
                obscureText: isObscureText ? true : false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  _changePassword();
                },
                child: Text('Save')),
          ],
        ),
      ),
    );
  }
}
