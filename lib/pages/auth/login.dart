import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '/components/textfield.dart';
import '/pages/auth/register.dart';
import '/pages/home.dart';
import '/components/logotile.dart';
import '/components/button.dart';
import '/utils/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final username = TextEditingController();
  final password = TextEditingController();

  final _storage = const FlutterSecureStorage();

  String? usernameError;
  String? passwordError;
  String? nonFieldError;

  void submit() async {
    FocusScope.of(context).unfocus();

    setState(() {
      usernameError = null;
      passwordError = null;
      nonFieldError = null;
    });

    try {
      final dio = Dio();
      dio.options.validateStatus = (status) {
        return status! >= 200 && status < 500;
      };
      final response = await dio.post(
        '${dotenv.env['API_URL']}/auth/login',
        data: {
          'username': username.text,
          'password': password.text,
        },
      );

      if (response.statusCode == 200) {
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
          usernameError =
              errors['username'] is List ? errors['username'][0] : null;
          passwordError =
              errors['password'] is List ? errors['password'][0] : null;
        });
      } else if (response.statusCode == 401) {
        final errors = response.data;
        setState(() {
          nonFieldError = errors['detail'];
        });
      } else {
        debugPrint('Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }

    setState(() {
      password.text = '';
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
                      'Welcome back! Sign in now and let your adventures continue',
                      style: TextStyle(
                        color: Color.fromARGB(255, 29, 29, 29),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (nonFieldError != null)
                      Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            nonFieldError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
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
                      controller: password,
                      labelText: 'Password',
                      hintText: '••••••••',
                      obscureText: true,
                      error: passwordError,
                      onChanged: (value) {
                        setState(() {
                          passwordError = null;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomButton(
                      label: 'Sign In',
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
                          'Not a member?',
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          child: const Text(
                            'Register now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageBuilder.createPageRoute(const RegisterPage()),
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
