part of '../pages.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isObscureText = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseService firebaseService = FirebaseService();

  void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email and password cannot be empty.'),
        ),
      );
    } else {
      final user = await firebaseService.signIn(email, password);
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid email or password.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
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
                welcomeBackText,
                style: welcomeTextStyle,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                subWelcomeBackText,
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
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
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
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(hintSignIn, style: hintTextStyle),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                hintOtherSignInOptions,
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
                    hintDontHaveAccount,
                    style: subWelcomeTextStyle,
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/sign-up');
                      },
                      child: Text(hintSignUp))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
