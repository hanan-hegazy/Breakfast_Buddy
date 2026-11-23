import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../features/auth/services/user_service.dart';
import '../../User_pages/customer_main_screen.dart';

import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_field_label.dart';
import '../../widgets/custom_button.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Create Account Function
  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Create account in Firebase Authentication
      UserCredential userCredential = await _authService.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Get the newly created user
      User? user = userCredential.user;

      if (user == null) {
        throw Exception('User account could not be created.');
      }

      // Save user information in Firestore
      await _userService.createUserProfile(
        user: user,
        name: _nameController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 400),
        ),
      );

      // Navigate to Customer Home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const CustomerMainScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered.';
          break;

        case 'invalid-email':
          message = 'Please enter a valid email.';
          break;

        case 'weak-password':
          message = 'Please choose a stronger password.';
          break;

        case 'operation-not-allowed':
          message = 'Email and password registration is not enabled.';
          break;

        case 'network-request-failed':
          message = 'Please check your internet connection.';
          break;

        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;

        default:
          message = 'Registration failed. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account was created, but saving your profile failed. Please contact support.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 43,
                      height: 43,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.peachBorder),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: AppColors.primaryBrown,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Breakfast Buddy',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBrown,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 43),
                  ],
                ),

                const SizedBox(height: 28),

                // Coffee illustration
                Center(
                  child: Container(
                    width: 105,
                    height: 105,
                    decoration: const BoxDecoration(
                      color: AppColors.peach,
                      shape: BoxShape.circle,
                    ),
                    child: const Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.coffee,
                          size: 58,
                          color: AppColors.primaryBrown,
                        ),
                        Positioned(
                          bottom: 15,
                          right: 15,
                          child: Icon(
                            Icons.bakery_dining,
                            size: 30,
                            color: AppColors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                const Center(
                  child: Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                ),

                const SizedBox(height: 7),

                const Center(
                  child: Text(
                    'Wake up to artisan pastries & fresh coffee every day.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),

                const SizedBox(height: 27),

                // Full Name
                const CustomFieldLabel(text: 'Full Name'),

                CustomTextField(
                  controller: _nameController,
                  hint: 'Emma Watson',
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 17),

                // Email
                const CustomFieldLabel(text: 'Email Address'),

                CustomTextField(
                  controller: _emailController,
                  hint: 'emma@example.com',
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 17),

                // Password
                const CustomFieldLabel(text: 'Password'),

                CustomTextField(
                  controller: _passwordController,
                  hint: 'At least 8 characters',
                  icon: Icons.lock_outline,
                  obscureText: !_showPassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    icon: Icon(
                      _showPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.mutedText,
                      size: 19,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }

                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 17),

                // Confirm Password
                const CustomFieldLabel(text: 'Confirm Password'),

                CustomTextField(
                  controller: _confirmPasswordController,
                  hint: 'Re-enter password',
                  icon: Icons.lock_outline,
                  obscureText: !_showConfirmPassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                    icon: Icon(
                      _showConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.mutedText,
                      size: 19,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }

                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Terms
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                      ),
                      children: [
                        TextSpan(text: 'By signing up, you agree to our '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: AppColors.primaryBrown,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: ' &\n'),
                        TextSpan(
                          text: 'Privacy Policy.',
                          style: TextStyle(
                            color: AppColors.primaryBrown,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // Create Account Button
                CustomButton(text: 'Create Account', onPressed: _createAccount),

                const SizedBox(height: 20),

                // Login
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.darkText,
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.orange,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
