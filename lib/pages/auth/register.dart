import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '/components/textfield.dart';
import '/components/button.dart';
import '/components/logotile.dart';
import '/pages/auth/login.dart';
import '/pages/home.dart';
import '/utils/routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final email = TextEditingController();
  final username = TextEditingController();
  final password1 = TextEditingController();
  final password2 = TextEditingController();

  final _storage = const FlutterSecureStorage();

  String? emailError, usernameError, password1Error, password2Error;

  void submit() async {
    FocusScope.of(context).unfocus();

    setState(() {
      emailError = null;
      usernameError = null;
      password1Error = null;
      password2Error = null;
    });

    try {
      final dio = Dio();
      dio.options.validateStatus = (status) {
        return status! >= 200 && status < 500;
      };
      final response = await dio.post(
        '${dotenv.env['API_URL']}/auth/register',
        data: {
          'email': email.text,
          'username': username.text,
          'password1': password1.text,
          'password2': password2.text,
        },
      );

      if (response.statusCode == 201) {
        final results = response.data;
        _storage.write(key: 'refresh', value: results['refresh']);
        _storage.write(key: 'access', value: results['access']);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          PageBuilder.createPageRoute(const HomePage()),
        );
      } else if (response.statusCode == 400) {
        final errors = response.data;
        setState(() {
          emailError = errors['email'] is List ? errors['email'][0] : null;
          usernameError =
              errors['username'] is List ? errors['username'][0] : null;
          password1Error =
              errors['password1'] is List ? errors['password1'][0] : null;
          password2Error =
              errors['password2'] is List ? errors['password2'][0] : null;
        });
      } else {
        debugPrint('Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }

    setState(() {
      password1.text = '';
      password2.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Center(
                      child: Icon(
                        Icons.timeline,
                        size: 50,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Welcome! Sign up now and let your adventures begin',
                      style: TextStyle(
                        color: Color.fromARGB(255, 29, 29, 29),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: email,
                      labelText: 'Email',
                      hintText: 'jtamad@fitquest.com',
                      obscureText: false,
                      error: emailError,
                      onChanged: (value) {
                        setState(() {
                          emailError = null;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: username,
                      labelText: 'Username',
                      hintText: 'jtamad',
                      obscureText: false,
                      error: usernameError,
                      onChanged: (value) {
                        setState(() {
                          usernameError = null;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: password1,
                      labelText: 'Password',
                      hintText: '••••••••',
                      obscureText: true,
                      error: password1Error,
                      onChanged: (value) {
                        setState(() {
                          password1Error = null;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: password2,
                      labelText: 'Password Confirmation',
                      hintText: '••••••••',
                      obscureText: true,
                      error: password2Error,
                      onChanged: (value) {
                        setState(() {
                          password2Error = null;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      label: 'Sign Up',
                      onTap: submit,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          child: Text(
                            'Or continue with',
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomLogoTile(
                          path: 'lib/images/google-logo.png',
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomLogoTile(
                          path: 'lib/images/facebook-logo.png',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Have an account?',
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          child: const Text(
                            'Login here',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              PageBuilder.createPageRoute(const LoginPage()),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
