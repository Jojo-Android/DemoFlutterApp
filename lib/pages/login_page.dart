import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:demo_flutter_app/l10n/app_localizations.dart';
import 'package:demo_flutter_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../db/auth_session.dart';
import '../db/user_db_helper.dart';
import '../notifiers/user_notifier.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscurePass = true;
  bool _isLoading = false;

  String _hashPassword(String raw) {
    return sha256.convert(utf8.encode(raw)).toString();
  }

  Future<void> _login() async {
    final localizations = AppLocalizations.of(context)!;

    final formState = _formKey.currentState;
    if (formState == null) return;

    if (!formState.saveAndValidate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final values = formState.value;
    final email = values['email']?.toString().trim() ?? '';
    final password = values['password']?.toString() ?? '';

    try {
      final user = await UserDBHelper.instance.getUserByEmail(email);
      if (user == null || user.password != _hashPassword(password)) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(localizations.loginFailed)));
      } else {
        context.read<UserNotifier>().setUser(user);
        await AuthSession.setLoggedInEmail(user.email);
        if (!mounted) return;

        context.goNamed(AppRoutes.main);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(localizations.loginGenericError)));
      debugPrint('Login error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goToRegister() {
    context.pushNamed(AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimaryColor = theme.colorScheme.onPrimary;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 80,
                  color: primaryColor,
                ),
                const SizedBox(height: 20),
                Text(
                  localizations.loginPageTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 28),

                // Email Field
                FormBuilderTextField(
                  name: 'email',
                  decoration: InputDecoration(
                    labelText: localizations.loginEmailLabel,
                    prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: localizations.loginInvalidEmail,
                    ),
                    FormBuilderValidators.email(
                      errorText: localizations.loginInvalidEmail,
                    ),
                  ]),
                ),
                const SizedBox(height: 16),

                // Password Field
                FormBuilderTextField(
                  name: 'password',
                  obscureText: _obscurePass,
                  decoration: InputDecoration(
                    labelText: localizations.loginPasswordLabel,
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
                  validator: FormBuilderValidators.required(
                    errorText: localizations.loginEmptyPassword,
                  ),
                ),

                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: onPrimaryColor,
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
                        ? CircularProgressIndicator(color: onPrimaryColor)
                        : Text(localizations.loginButton),
                  ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: _goToRegister,
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor.withOpacity(0.9),
                    textStyle: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Text(localizations.loginRegisterLink),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
