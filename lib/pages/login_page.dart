import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/auth_session.dart';
import '../db/user_db_helper.dart';
import '../notifiers/user_notifier.dart';
import 'main_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();

  bool _obscurePass = true;
  String? _error;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  String _hashPassword(String raw) {
    return sha256.convert(utf8.encode(raw)).toString();
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  Future<void> _login() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();

    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;

    if (!_isValidEmail(email)) {
      setState(() => _error = 'รูปแบบอีเมลไม่ถูกต้อง');
      _emailFocus.requestFocus();
      return;
    }

    if (password.trim().isEmpty) {
      setState(() => _error = 'กรุณากรอกรหัสผ่าน');
      _passFocus.requestFocus();
      return;
    }

    if (!mounted) return;
    setState(() {
      _error = null;
      _isLoading = true;
    });

    try {
      final user = await UserDBHelper.instance.getUserByEmail(email);
      if (user == null || user.password != _hashPassword(password)) {
        setState(() => _error = 'อีเมลหรือรหัสผ่านไม่ถูกต้อง');
        return;
      }

      context.read<UserNotifier>().setUser(user);
      await AuthSession.setLoggedInEmail(user.email);
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainPage(user: user)),
      );
    } catch (e) {
      setState(() => _error = 'เกิดข้อผิดพลาด กรุณาลองใหม่');
      debugPrint('Login error: $e'); // สำหรับ dev เท่านั้น
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimaryColor = theme.colorScheme.onPrimary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shopping_bag_outlined, size: 80, color: primaryColor),
              const SizedBox(height: 20),
              Text(
                'เข้าสู่ระบบ',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 28),

              // Email Field
              TextField(
                controller: _emailCtrl,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(
                  labelText: 'อีเมล',
                  prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
                onSubmitted: (_) => _passFocus.requestFocus(),
              ),
              const SizedBox(height: 16),

              // Password Field with toggle visibility
              TextField(
                controller: _passCtrl,
                focusNode: _passFocus,
                obscureText: _obscurePass,
                textInputAction: TextInputAction.done,
                autocorrect: false,
                autofillHints: const [AutofillHints.password],
                decoration: InputDecoration(
                  labelText: 'รหัสผ่าน',
                  prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePass ? Icons.visibility_off : Icons.visibility,
                      color: primaryColor,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePass = !_obscurePass),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
                onSubmitted: (_) => _login(),
              ),

              if (_error != null) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _error!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    // ตัวหนังสือสีขาว
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 8,
                    shadowColor: primaryColor.withOpacity(0.6),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : const Text('เข้าสู่ระบบ'),
                ),
              ),

              const SizedBox(height: 12),

              // Go to Register - เน้นลิงก์ให้ดูโดดเด่นและกดง่าย
              TextButton(
                onPressed: _goToRegister,
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor.withOpacity(0.9),
                  textStyle: const TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('ยังไม่มีบัญชี? สมัครสมาชิกที่นี่'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
