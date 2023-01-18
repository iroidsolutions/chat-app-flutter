import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/auth_services.dart';
import 'registration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();

  String email = '';
  String pass = '';

  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool visible = false;

  void getvalidation() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      email = emailController.text;
      pass = passController.text;

      AuthService.authService.login(email, pass);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 52, right: 36, top: 24),
                  child: Image.asset('assets/homeScreen.png'),
                ),
                const SizedBox(
                  height: 19,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 19, top: 19),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 27,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 19,
                    ),
                    Image.asset(
                      'assets/At sign.png',
                      width: 23,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 12,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) return "Please Enter Email";

                            if (!value.contains("@gmail.com")) {
                              return "Please check the email";
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 19,
                    ),
                    Image.asset(
                      'assets/Lock.png',
                      width: 23,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 12,
                        ),
                        child: TextFormField(
                          controller: passController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !visible,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("plase enter password");
                            }
                            if (value.length < 6) {
                              return ("Plase enter password greater than 6 character");
                            }
                            if (!value.contains('@'))
                              return "please contain special chararcter";
                          },
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                visible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  visible = !visible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 7, right: 12),
                  alignment: Alignment.topRight,
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(
                      color: Color(0xff5B94E3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                MaterialButton(
                  onPressed: () {
                    getvalidation();
                    // usingSQL();
                  },
                  minWidth: 300,
                  height: 47,
                  color: const Color(0xff317FED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: const Divider(
                          height: 36,
                        ),
                      ),
                    ),
                    const Text('OR'),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: const Divider(
                          height: 36,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'New to Soci? ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ((context) => const Registration()),
                          ),
                        );
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Color(0xff317FED),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 62,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
