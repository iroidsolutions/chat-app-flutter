import 'package:flutter/material.dart';
import '../auth/auth_services.dart';
import 'login_screen.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final key = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  String? email;
  String? pass;
  String? username;

  void getsignIn() {
    FocusScope.of(context).unfocus();
    print(key.currentState!.validate());
    if (key.currentState!.validate()) {
      email = emailController.text.trim();
      pass = passController.text.trim();
      username = usernameController.text.trim();
      AuthService.authService
          .registration(email ?? '', pass ?? '', username ?? '');
    }
  }

  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: key,
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
                    'Registration',
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
                    const Icon(Icons.account_circle_outlined),
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
                          controller: usernameController,
                          validator: (value) {
                            if (value!.isEmpty) return "Please Enter username";

                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Username',
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
                            return null;
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
                            if (!value.contains('@')) {
                              return "please contain special chararcter";
                            }

                            return null;
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
                const SizedBox(
                  height: 32,
                ),
                MaterialButton(
                  onPressed: () {
                    getsignIn();
                  },
                  minWidth: 100,
                  height: 47,
                  color: const Color(0xff317FED),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text(
                    'Registration',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already Sign In ?'),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        ' login',
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
