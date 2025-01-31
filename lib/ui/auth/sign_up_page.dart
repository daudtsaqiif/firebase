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
    role = ['user', 'admin'];
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
          'password': passwordController.text,
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
      body: Center(
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return 'Email tidak valid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              controller: firstNameController,
                              decoration: InputDecoration(
                                hintText: hintFirstName,
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'first name tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextFormField(
                              controller: lastNameController,
                              decoration: InputDecoration(
                                hintText: hintLastName,
                                prefixIcon: Icon(Icons.person_add_alt_1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'last name tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black54,
                      ),
                    ),
                    child: DropdownButton(
                      value: selectedRole,
                      items: role!
                          .map(
                              (e) => DropdownMenuItem(child: Text(e), value: e))
                          .toList(),
                      onChanged: (item) {
                        setState(() {
                          selectedRole = item.toString();
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: hintPassword,
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
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        if (value.length <= 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: hintConfirmPassword,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        if (value.length <= 6) {
                          return 'Password minimal 6 karakter';
                        }
                        if (value != passwordController.text) {
                          return 'Password tidak sama';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: GestureDetector(
                      onTap: () {
                        print(hintForgotPassword);
                      },
                      child: Text(
                        hintForgotPassword,
                        textAlign: TextAlign.end,
                        style: subWelcomeTextStyle,
                      ),
                    ),
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
                              backgroundColor: colorPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(hintSignUp, style: hintTextStyle)),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      hintOtherSignUpOptions,
                      style: subWelcomeTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                image: DecorationImage(
                                  image: AssetImage(imageGoogle),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              hintGoogle,
                              style: welcomeTextStyle.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                image: DecorationImage(
                                  image: AssetImage(imageFacebook),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(hintFacebook,
                                style: welcomeTextStyle.copyWith(fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
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
}
