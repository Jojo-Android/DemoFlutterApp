import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../db/user_db_helper.dart';
import '../model/user_model.dart';
import '../widgets/avatar_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ValueNotifier<bool> _isFormValid = ValueNotifier(false);
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  String? _imagePath;
  bool _isLoading = false;

  @override
  void dispose() {
    _isFormValid.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final savedImage = await File(picked.path).copy('${appDir.path}/$fileName');

      setState(() => _imagePath = savedImage.path);
      _checkFormValidity();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถเลือกภาพได้: $e')),
      );
    }
  }

  String _hashPassword(String raw) => sha256.convert(utf8.encode(raw)).toString();

  Future<void> _register() async {
    final form = _formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;

    setState(() => _isLoading = true);

    final values = form.value;
    final name = values['name'].toString().trim();
    final email = values['email'].toString().trim().toLowerCase();
    final password = values['password'].toString().trim();

    try {
      final existingUser = await UserDBHelper().getUserByEmail(email);
      if (existingUser != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('อีเมลนี้ถูกใช้แล้ว')));
        setState(() => _isLoading = false);
        return;
      }

      final hashedPass = _hashPassword(password);
      final user = UserModel(
        name: name,
        email: email,
        password: hashedPass,
        imagePath: _imagePath,
      );

      await UserDBHelper().saveUser(user);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('สมัครสมาชิกสำเร็จ')));

      form.reset();
      setState(() {
        _imagePath = null;
        _obscurePass = true;
        _obscureConfirm = true;
        _isLoading = false;
      });
      _isFormValid.value = false;
      Navigator.pop(context); // กลับหน้าก่อนหน้า
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
      setState(() => _isLoading = false);
    }
  }

  void _checkFormValidity() {
    final form = _formKey.currentState;
    if (form == null) return;

    form.save();
    final values = form.value;
    final requiredFields = ['name', 'email', 'password', 'confirm_password'];

    final hasAllValues = requiredFields.every((key) {
      final val = values[key];
      return val != null && val.toString().trim().isNotEmpty;
    });

    final hasNoErrors = requiredFields.every((key) {
      final error = form.fields[key]?.errorText;
      return error == null;
    });

    _isFormValid.value = hasAllValues && hasNoErrors;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimaryColor = theme.colorScheme.onPrimary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('สมัครสมาชิก'),
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        elevation: 4,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FormBuilder(
            key: _formKey,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Center(
                  child: AvatarPicker(imagePath: _imagePath, onTap: _pickImage),
                ),
                const SizedBox(height: 24),
                // Name
                FormBuilderTextField(
                  name: 'name',
                  decoration: InputDecoration(
                    labelText: 'ชื่อ',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    prefixIcon: Icon(Icons.person_outline, color: primaryColor),
                  ),
                  validator: FormBuilderValidators.required(errorText: 'กรุณากรอกชื่อ'),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _formKey.currentState?.fields['name']?.validate();
                    _checkFormValidity();
                    FocusScope.of(context).nextFocus();
                  },
                ),
                const SizedBox(height: 16),

                // Email
                FormBuilderTextField(
                  name: 'email',
                  decoration: InputDecoration(
                    labelText: 'อีเมล',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    prefixIcon: Icon(Icons.email_outlined, color: primaryColor),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'กรุณากรอกอีเมล'),
                    FormBuilderValidators.email(errorText: 'รูปแบบอีเมลไม่ถูกต้อง'),
                  ]),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _formKey.currentState?.fields['email']?.validate();
                    _checkFormValidity();
                    FocusScope.of(context).nextFocus();
                  },
                ),
                const SizedBox(height: 16),

                // Password
                FormBuilderTextField(
                  name: 'password',
                  obscureText: _obscurePass,
                  decoration: InputDecoration(
                    labelText: 'รหัสผ่าน',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePass ? Icons.visibility : Icons.visibility_off,
                        color: primaryColor,
                      ),
                      onPressed: () => setState(() {
                        _obscurePass = !_obscurePass;
                      }),
                      splashRadius: 24,
                      tooltip: _obscurePass ? 'แสดงรหัสผ่าน' : 'ซ่อนรหัสผ่าน',
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'กรุณากรอกรหัสผ่าน'),
                    FormBuilderValidators.minLength(6, errorText: 'อย่างน้อย 6 ตัว'),
                  ]),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _formKey.currentState?.fields['password']?.validate();
                    _checkFormValidity();
                    FocusScope.of(context).nextFocus();
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password
                FormBuilderTextField(
                  name: 'confirm_password',
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'ยืนยันรหัสผ่าน',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                        color: primaryColor,
                      ),
                      onPressed: () => setState(() {
                        _obscureConfirm = !_obscureConfirm;
                      }),
                      splashRadius: 24,
                      tooltip: _obscureConfirm ? 'แสดงรหัสผ่าน' : 'ซ่อนรหัสผ่าน',
                    ),
                  ),
                  validator: (val) {
                    final pass = _formKey.currentState?.fields['password']?.value?.toString().trim() ?? '';
                    if (val == null || val.trim().isEmpty) {
                      return 'กรุณายืนยันรหัสผ่าน';
                    }
                    if (val.trim() != pass) {
                      return 'รหัสผ่านไม่ตรงกัน';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () {
                    _formKey.currentState?.fields['confirm_password']?.validate();
                    _checkFormValidity();
                    FocusScope.of(context).unfocus();
                  },
                ),

                const SizedBox(height: 32),

                ValueListenableBuilder<bool>(
                  valueListenable: _isFormValid,
                  builder: (_, isValid, __) {
                    return SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isValid && !_isLoading ? _register : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: onPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                          shadowColor: primaryColor.withOpacity(0.4),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: onPrimaryColor, strokeWidth: 2),
                        )
                            : const Text('สมัครสมาชิก'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
