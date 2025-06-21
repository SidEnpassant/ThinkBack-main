import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';
import '../widgets/input_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: const _LoginScreenBody(),
    );
  }
}

class _LoginScreenBody extends StatelessWidget {
  const _LoginScreenBody();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 77),
                    const Text(
                      'Welcome to\nThinkBack',
                      style: TextStyle(
                        fontFamily: 'SF Pro Rounded',
                        fontWeight: FontWeight.w400,
                        fontSize: 39,
                        color: Color(0xFF242426),
                        height: 1,
                        letterSpacing: 0.36,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Please enter your username and password to \nlog in to your account.',
                      style: TextStyle(
                        fontFamily: 'SF Pro Rounded',
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                        color: Color(0xFF363638),
                        height: 1.29,
                        letterSpacing: -0.41,
                      ),
                    ),
                    const SizedBox(height: 56),
                    InputField(
                      icon: Icons.email_outlined,
                      hint: 'Input your email',
                      onChanged: provider.setEmail,
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      icon: Icons.lock_outline,
                      hint: 'Input your password',
                      onChanged: provider.setPassword,
                      obscureText: !provider.isPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          provider.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xFFAEAEB2),
                        ),
                        onPressed: provider.togglePasswordVisibility,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontFamily: 'SF Pro Rounded',
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Color(0xFF507BFA),
                            height: 1.33,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed:
                            provider.isLoading
                                ? null
                                : () async {
                                  await provider.login();
                                  if (provider.token != null &&
                                      provider.errorMessage == null) {
                                    Navigator.of(
                                      context,
                                    ).pushReplacementNamed('/home');
                                  }
                                },
                        child:
                            provider.isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  'Log In',
                                  style: TextStyle(
                                    fontFamily: 'SF Pro',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: Colors.white,
                                    height: 1.29,
                                    letterSpacing: -0.41,
                                  ),
                                ),
                      ),
                    ),
                    if (provider.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          provider.errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Color(0xFF242426),
                            thickness: 1,
                            endIndent: 8,
                            indent: 0,
                          ),
                        ),
                        Opacity(
                          opacity: 0.7,
                          child: const Text(
                            'or',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Color(0xFF242426),
                              height: 1.33,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Color(0xFF242426),
                            thickness: 1,
                            indent: 8,
                            endIndent: 0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF242426)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: Image.asset(
                          'assets/google_icon.png',
                          width: 24,
                          height: 24,
                        ),
                        label: const Text(
                          'Google',
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: Color(0xFF242426),
                            height: 1.29,
                            letterSpacing: -0.41,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: const Text(
                          "Don't have an account? Sign Up",
                          style: TextStyle(
                            fontFamily: 'SF Pro Rounded',
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Color(0xFF507BFA),
                            height: 1.33,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Status bar and home indicator can be added as overlays if needed
          ],
        ),
      ),
    );
  }
}
