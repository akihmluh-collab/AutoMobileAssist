import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_mobile_assist/l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import 'register_screen.dart';

typedef LanguageCallback = void Function(Locale locale);

class LoginScreen extends StatefulWidget {
  final LanguageCallback? onLanguageChanged;
  const LoginScreen({super.key, this.onLanguageChanged});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String _selectedLanguage = 'EN';
  String _errorMessage = '';

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.translate('please_fill_fields'))),
        );
      }
      return;
    }

    // Validate email format
    if (!_emailController.text.contains('@') || !_emailController.text.contains('.')) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.translate('invalid_email'))),
        );
      }
      return;
    }

    // Validate password length
    if (_passwordController.text.length < 6) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.translate('invalid_password'))),
        );
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
    }
    
    final auth = Provider.of<AuthProvider>(context, listen: false);
    bool success = await auth.login(_emailController.text, _passwordController.text);
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.translate('login_success'))),
        );
      }
    } else {
      if (mounted) {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.translate('login_failed');
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.translate('login_failed'))),
        );
      }
    }
  }

  Widget _buildLanguageButton(String lang) {
    final isSelected = _selectedLanguage == lang;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = lang;
        });
        // Call the callback to change language
        widget.onLanguageChanged?.call(lang == 'EN' ? const Locale('en') : const Locale('fr'));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          lang == 'EN' 
              ? AppLocalizations.of(context)!.translate('english')
              : AppLocalizations.of(context)!.translate('french'),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Debug: Check if translations exist
    print('Locale: ${Localizations.localeOf(context).languageCode}');
    print('Translation for login_title: ${AppLocalizations.of(context)?.translate('login_title')}');
    
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.translate('app_name'),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.translate('login_title'),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLanguageButton('EN'),
                const SizedBox(width: 10),
                _buildLanguageButton('FR'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.translate('login_subtitle'),
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.translate('email'),
                prefixIcon: const Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.translate('password'),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
              obscureText: _obscurePassword,
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(AppLocalizations.of(context)!.translate('login_button')),
                  ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: Text(AppLocalizations.of(context)!.translate('new_user')),
            ),
          ],
        ),
      ),
    );
  }
}