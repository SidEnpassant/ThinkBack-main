import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/signup_provider.dart';
import '../widgets/input_field.dart';
import '../screens/login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupProvider(),
      child: const _SignupScreenBody(),
    );
  }
}

class _SignupScreenBody extends StatelessWidget {
  const _SignupScreenBody();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProvider>(context);
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
                    const SizedBox(height: 10),
                    // Back arrow
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Color(0xFF242426),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      'Sign Up',
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
                      "To register for an account, complete the registration form with your correct information and click the 'Register' button.",
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
                      icon: Icons.person_outline,
                      hint: 'Input your full name',
                      onChanged: provider.setFullName,
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    InputField(
                      icon: Icons.lock_outline,
                      hint: 'Verify password',
                      onChanged: provider.setVerifyPassword,
                      obscureText: !provider.isVerifyPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          provider.isVerifyPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xFFAEAEB2),
                        ),
                        onPressed: provider.toggleVerifyPasswordVisibility,
                      ),
                    ),
                    const SizedBox(height: 40),
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
                                  await provider.signup();
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
                                  'Sign Up',
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
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),

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
                        onPressed:
                            provider.isLoading
                                ? null
                                : () async {
                                  await provider.googleSignup();
                                  if (provider.token != null &&
                                      provider.errorMessage == null) {
                                    Navigator.of(
                                      context,
                                    ).pushReplacementNamed('/home');
                                  }
                                },
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
