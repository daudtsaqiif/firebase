part of '../pages.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool isObscureText = true;
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController NewPasswordController = TextEditingController();
  TextEditingController ConfrimPasswordController = TextEditingController();

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
            ElevatedButton(onPressed: () {}, child: Text('Save')),
          ],
        ),
      ),
    );
  }
}
