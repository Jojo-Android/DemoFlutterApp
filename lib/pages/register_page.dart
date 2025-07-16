import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../db/user_db_helper.dart';
import '../l10n/app_localizations.dart';
import '../model/user_model.dart';
import '../widgets/avatar_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _isFormFilled = ValueNotifier(false);
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _imagePath;

  @override
  void dispose() {
    _isFormFilled.dispose();
    super.dispose();
  }

  void _checkFormFilled() {
    final form = _formKey.currentState;
    if (form == null) return;

    form.save();
    final values = form.value;
    final requiredFields = ['name', 'email', 'password', 'confirm_password'];

    final filled = requiredFields.every((key) {
      final val = values[key];
      return val != null && val.toString().trim().isNotEmpty;
    });

    _isFormFilled.value = filled;
  }

  String _hashPassword(String raw) =>
      sha256.convert(utf8.encode(raw)).toString();

  Future<void> _pickImage() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final saved = await File(picked.path).copy('${appDir.path}/$fileName');

      setState(() => _imagePath = saved.path);
      _checkFormFilled();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.registerPickImageFailedWithError(e.toString())),
        ),
      );
    }
  }

  Future<void> _register() async {
    final form = _formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);

    final values = form.value;
    final name = values['name'].toString().trim();
    final email = values['email'].toString().trim().toLowerCase();
    final password = values['password'].toString().trim();

    try {
      final existingUser = await UserDBHelper().getUserByEmail(email);
      if (existingUser != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.registerEmailInUse)));
        setState(() => _isLoading = false);
        return;
      }

      final user = UserModel(
        name: name,
        email: email,
        password: _hashPassword(password),
        imagePath: _imagePath,
      );
      await UserDBHelper().saveUser(user);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.registerSuccess)));

      form.reset();
      setState(() {
        _isLoading = false;
        _imagePath = null;
        _obscurePassword = true;
        _obscureConfirm = true;
      });
      _isFormFilled.value = false;
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.registerFormGenericError(e.toString()))),
      );
      setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: theme.colorScheme.primary),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.registerPageTitle),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FormBuilder(
            key: _formKey,
            onChanged: _checkFormFilled,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Center(
                  child: AvatarPicker(imagePath: _imagePath, onTap: _pickImage),
                ),
                const SizedBox(height: 24),
                FormBuilderTextField(
                  name: 'name',
                  decoration: _inputDecoration(
                    label: l10n.registerNameLabel,
                    icon: Icons.person,
                  ),
                  validator: FormBuilderValidators.required(
                    errorText: l10n.registerFieldRequiredName,
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'email',
                  decoration: _inputDecoration(
                    label: l10n.registerEmailLabel,
                    icon: Icons.email,
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: l10n.registerFieldRequiredEmail,
                    ),
                    FormBuilderValidators.email(
                      errorText: l10n.registerFormInvalidEmail,
                    ),
                  ]),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'password',
                  obscureText: _obscurePassword,
                  decoration: _inputDecoration(
                    label: l10n.registerPasswordLabel,
                    icon: Icons.lock,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: l10n.registerFieldRequiredPassword,
                    ),
                    FormBuilderValidators.minLength(
                      6,
                      errorText: l10n.registerPasswordMinLength,
                    ),
                  ]),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'confirm_password',
                  obscureText: _obscureConfirm,
                  decoration: _inputDecoration(
                    label: l10n.registerConfirmPasswordLabel,
                    icon: Icons.lock,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  validator: (value) {
                    final password =
                        _formKey.currentState?.fields['password']?.value
                            ?.toString()
                            .trim() ??
                        '';
                    if (value == null || value.trim().isEmpty) {
                      return l10n.registerConfirmPasswordEmpty;
                    }
                    if (value.trim() != password) {
                      return l10n.registerConfirmPasswordMismatch;
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 32),
                ValueListenableBuilder<bool>(
                  valueListenable: _isFormFilled,
                  builder: (_, filled, __) => SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: filled && !_isLoading ? _register : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 6,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.registerButton),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
