import 'package:flutter/material.dart';
import 'package:recipedekhoapp/services/auth_service.dart';
import 'package:recipedekhoapp/services/snackbar_service.dart';
import 'package:recipedekhoapp/services/storage_service.dart';
import 'package:recipedekhoapp/widgets/base_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isRegistered = false;
  bool hidePassword = true;
  bool isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final AuthService authService = AuthService();
  final StorageService storageService = StorageService();

  void handleAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      Map<String, dynamic> response;

      if (isRegistered) {
        response = await authService.register(
          _fullNameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        response = await authService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      }

      if (response['jwt'] != null) {
        await storageService.saveJwt(response['jwt']);
        SnackbarService.showSnackbar(context, response['message']);
        Navigator.pushNamed(context, '/home');
      } else {
        SnackbarService.showSnackbar(
          context,
          response['error'] ?? 'Something went wrong',
          isError: true,
        );
      }
    } catch (e) {
      SnackbarService.showSnackbar(
        context,
        'An error occurred. Try again.',
        isError: true,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'RecipeDekho',
      showDrawer: false,
      showBottomNav: false,
      showFloatingActionButton: false,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              isRegistered
                  ? 'https://img.sndimg.com/food/image/upload/q_92,fl_progressive/v1/img/recipes/74/48/3/nxAqazgQa2Lq3bQreAAU_098-grilled-beer-chicken.jpg'
                  : 'https://th.bing.com/th/id/OIP.JrFWrkKOgvsFeMa2wap_HwHaE8?rs=1&pid=ImgDetMain',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.black,
                  child: const Center(
                    child: Text(
                      'Image failed to load',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned.fill(child: Container(color: Colors.black.withAlpha(150))),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      isRegistered ? 'Join Us!' : 'Welcome Back!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isRegistered
                          ? 'Register to unlock exciting opportunities.'
                          : 'Login to explore the amazing features.',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            isRegistered ? 'Register' : 'Login',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          if (isRegistered)
                            Column(
                              children: [
                                TextFormField(
                                  controller: _fullNameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _inputDecoration('Full Name*'),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Name is required';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),

                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration('Email*'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: hidePassword,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration('Password*').copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  hidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                                onPressed:
                                    () => setState(
                                      () => hidePassword = !hidePassword,
                                    ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),

                          isLoading
                              ? const CircularProgressIndicator(
                                  color: Color(0xFFFFABF3),
                                )
                              : ElevatedButton(
                                  onPressed: handleAuth,
                                  child:
                                      Text(isRegistered ? 'Sign Up' : 'Login'),
                                ),
                          const SizedBox(height: 20),

                          GestureDetector(
                            onTap:
                                () => setState(
                                  () => isRegistered = !isRegistered,
                                ),
                            child: Text(
                              isRegistered
                                  ? 'Already have an account? Login'
                                  : 'Don\'t have an account? Sign Up',
                              style: const TextStyle(
                                color: Color(0xFFFFABF3),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      floatingLabelStyle: const TextStyle(
        color: Color(0xFFFFABF3),
        fontWeight: FontWeight.bold,
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: const UnderlineInputBorder(),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFFABF3), width: 2),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white70, width: 1),
      ),
      hintStyle: const TextStyle(color: Colors.white70),
    );
  }
}
