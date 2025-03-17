part of '../pages.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isObscureText = true;
  bool isLoading = false;

  final _auth = FirebaseService();
  final _firebaseStore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  List<String>? role;
  String? selectedRole;

  @override
  void initState() {
    role = ['student', 'teacher', 'admin'];
    selectedRole = role![0];
    super.initState();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      User? user =
          (await _auth.signUp(emailController.text, passwordController.text));
      if (user != null) {
        await _firebaseStore.collection('users').doc(user.uid).set({
          'email': emailController.text,
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'role': selectedRole,
        });
        Navigator.pushReplacementNamed(context, '/home');

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registerasi berhasil! ${user.email}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      setState(() {
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                children: [
                  const SizedBox(height: 50),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: imageLogo,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      welcomeText,
                      style: welcomeTextStyle,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      subWelcomeText,
                      style: subWelcomeTextStyle,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Email:',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _buildTextField(
                        "Email",
                        emailController,
                        false,
                      )),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Name:',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: _buildTextField(
                                "First Name", firstNameController, false)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: _buildTextField(
                                "Last Name", lastNameController, false)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Role:',
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: DropdownButton(
                            value: selectedRole,
                            items: role!
                                .map((e) =>
                                    DropdownMenuItem(child: Text(e), value: e))
                                .toList(),
                            onChanged: (item) {
                              setState(() {
                                selectedRole = item.toString();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Password:",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(
                            "Password", passwordController, true),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text("Confrim Password:",
                          style: TextStyle(color: Colors.black, fontSize: 16)),
                      SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField("Confrim Password",
                            confirmPasswordController, true),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              _signUp();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(hintSignUp, style: hintTextStyle)),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          hintAlreadyHaveAccount,
                          style: subWelcomeTextStyle,
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/sign-in');
                            },
                            child: Text(hintSignIn))
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isPassword,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && isObscureText,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black54),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isObscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    isObscureText = !isObscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
