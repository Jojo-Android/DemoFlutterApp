import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import '../db/auth_session.dart';
import '../db/user_db_helper.dart';
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
  String? _error;

  @override
  void initState() {
    super.initState();

    _emailCtrl.addListener(() {
      if (_error != null) setState(() => _error = null);
    });
    _passCtrl.addListener(() {
      if (_error != null) setState(() => _error = null);
    });
  }

  String _hashPassword(String raw) {
    return sha256.convert(utf8.encode(raw)).toString();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;

    if (!_isValidEmail(email)) {
      setState(() => _error = 'รูปแบบอีเมลไม่ถูกต้อง');
      return;
    }

    final user = await UserDBHelper.instance.getUserByEmail(email);
    if (user == null || user.password != _hashPassword(password)) {
      setState(() => _error = 'อีเมลหรือรหัสผ่านไม่ถูกต้อง');
      return;
    }

    await AuthSession.setLoggedInEmail(user.email);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainPage(user: user)),
    );
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เข้าสู่ระบบ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'อีเมล'),
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
            ),
            TextField(
              controller: _passCtrl,
              decoration: const InputDecoration(labelText: 'รหัสผ่าน'),
              obscureText: true,
              autofillHints: const [AutofillHints.password],
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('เข้าสู่ระบบ')),
            TextButton(
              onPressed: _goToRegister,
              child: const Text('สมัครสมาชิก'),
            ),
          ],
        ),
      ),
    );
  }
}
