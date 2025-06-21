import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final ValueChanged<String> onChanged;
  final bool obscureText;
  final Widget? suffixIcon;

  const InputField({
    required this.icon,
    required this.hint,
    required this.onChanged,
    this.obscureText = false,
    this.suffixIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFAEAEB2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFAEAEB2)),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: const TextStyle(
                  fontFamily: 'SF Pro Rounded',
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  color: Color(0xFFAEAEB2),
                  height: 1.29,
                  letterSpacing: -0.41,
                ),
                suffixIcon: suffixIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
