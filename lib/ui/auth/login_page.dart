import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n_ext.dart';
import 'auth_view_model.dart';

/// หน้าเข้าสู่ระบบ/สมัครสมาชิกด้วยอีเมล (Firebase Authentication)
/// เมื่อสำเร็จ ไม่ต้องสั่งนำทางเอง: router จะ redirect ไปหน้าเมนูให้
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  bool _signUp = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final vm = context.read<AuthViewModel>();
    _signUp
        ? vm.signUp(_email.text, _password.text, _name.text)
        : vm.signIn(_email.text, _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Image.asset('assets/images/logo.png', height: 120),
              const SizedBox(height: 24),
              if (_signUp)
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(labelText: l10n.displayName),
                  validator: (v) => (v ?? '').trim().isEmpty ? '*' : null,
                ),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(labelText: l10n.email),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                validator: (v) => (v ?? '').contains('@') ? null : '*',
              ),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(labelText: l10n.password),
                obscureText: true, // ซ่อนรหัสผ่าน
                validator: (v) => (v ?? '').length >= 6 ? null : '≥ 6',
              ),
              const SizedBox(height: 16),
              if (vm.error != null)
                Text(
                  vm.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: vm.busy ? null : _submit,
                child: Text(_signUp ? l10n.signUp : l10n.signIn),
              ),
              TextButton(
                onPressed: () => setState(() => _signUp = !_signUp),
                child: Text(_signUp ? l10n.haveAccount : l10n.noAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
