part of 'shared.dart';

final colorPrimary = '1D1C36FF'.toColor();
final colorWhite = 'FFFFFFFF'.toColor();

final imageLogo = AssetImage('assets/images/mobil.jpg');
final imageGoogle = 'assets/icons/logo_google.png';
final imageFacebook = 'assets/icons/facebook_logo.png';

final welcomeBackText = 'Hello, Welcome Back 👋';
final welcomeText = 'Hello, Welcome To Our App 👋';

final subWelcomeText = ''
    'Let\'s Create your account with a smile 😁 '
    'and a cup of coffee ☕ '
    'Heve a nice day!';

final subWelcomeBackText = ''
    'Let\'s start your day with a smile 😁 '
    'and a cup of coffee ☕ '
    'Heve a nice day!';

final hintEmail = 'Email';
final hintPassword = 'Password';
final hintFirstName = 'First Name';
final hintLastName = 'Last Name';
final hintRole = 'Role';
final hintConfirmPassword = 'Confirm Password';
final hintForgotPassword = 'Forgot Password';
final hintSignIn = 'Sign In';
final hintSignUp = 'Sign Up';
final hintOtherSignInOptions = 'Other Sign In Options';
final hintOtherSignUpOptions = 'Other Sign Up Options';
final hintFacebook = 'Facebook';
final hintGoogle = 'Google';
final hintAlreadyHaveAccount = 'Already have an account?';
final hintDontHaveAccount = 'Doesn\'t have an account?';

TextStyle subWelcomeTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: Colors.black54,
);

TextStyle welcomeTextStyle = GoogleFonts.poppins(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);

TextStyle hintTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

TextStyle judulTextStyle = GoogleFonts.poppins(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);
