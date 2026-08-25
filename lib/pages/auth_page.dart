import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

import '../services/user_profile_service.dart';
import '../database/hive_service.dart';
import '../theme/app_gradients.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isLogin = true;
  bool loading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  bool checkingUsername = false;
  bool? usernameAvailable;

  Timer? _usernameTimer;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();

    _usernameController.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    _usernameTimer?.cancel();
    _animationController.dispose();

    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  String get username => _usernameController.text.trim();

  String get avatarLetter {
    if (username.isEmpty) return 'A';
    return username.substring(0, 1).toUpperCase();
  }

  void _onUsernameChanged() {
    if (!mounted || isLogin) return;

    _usernameTimer?.cancel();

    setState(() {
      usernameAvailable = null;
      checkingUsername = false;
    });

    final value = username;

    if (value.length < 3 ||
        value.length > 20 ||
        !RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return;
    }

    setState(() {
      checkingUsername = true;
    });

    _usernameTimer = Timer(
      const Duration(milliseconds: 500),
      () => _checkUsername(value),
    );
  }

  Future<void> _checkUsername(String value) async {
    try {
      final exists = await UserProfileService.usernameExists(value);

      if (!mounted) return;
      if (username != value) return;

      setState(() {
        checkingUsername = false;
        usernameAvailable = !exists;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        checkingUsername = false;
        usernameAvailable = null;
      });
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (!isLogin) {
      if (checkingUsername) {
        _showError('Please wait while we check your username.');
        return;
      }

      if (usernameAvailable != true) {
        _showError('Please choose an available username.');
        return;
      }
    }

    setState(() {
      loading = true;
    });

    try {
      final auth = FirebaseAuth.instance;

      if (isLogin) {
        final credential = await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        final user = credential.user;

        if (user != null) {
          final profile =
              await UserProfileService.getProfile(user.uid);

          if (profile.exists) {
            final data = profile.data();

            final profileUsername =
                data?['username']?.toString().trim() ?? '';

            if (profileUsername.isNotEmpty) {
              await HiveService.setUsername(profileUsername);
            }
          }
        }
      } else {
        final email = _emailController.text.trim();

        final credential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: _passwordController.text,
        );

        final user = credential.user;

        if (user == null) {
          throw Exception('Account could not be created.');
        }

        await user.updateDisplayName(username);

        await UserProfileService.createProfile(
          uid: user.uid,
          username: username,
          email: email,
          displayName: username,
        );

        await HiveService.setUsername(username);

        await user.reload();
      }
    } on FirebaseAuthException catch (e) {
      _showError(_firebaseMessage(e.code));
    } catch (e) {
      final message = e.toString();

      if (message.contains('Username is already taken')) {
        _showError(
          'This username is already taken. Please choose another one.',
        );
      } else {
        _showError('Something went wrong. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _showError('Enter your email address first.');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (!mounted) return;

      _showMessage('Password reset email sent.');
    } on FirebaseAuthException catch (e) {
      _showError(_firebaseMessage(e.code));
    }
  }

  String _firebaseMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-not-found':
        return 'No account was found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your internet connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  String? _validateUsername(String? value) {
    if (isLogin) return null;

    final valueTrimmed = value?.trim() ?? '';

    if (valueTrimmed.isEmpty) {
      return 'Username is required';
    }

    if (valueTrimmed.length < 3) {
      return 'Minimum 3 characters';
    }

    if (valueTrimmed.length > 20) {
      return 'Maximum 20 characters';
    }

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(valueTrimmed)) {
      return 'Use letters, numbers and _ only';
    }

    if (usernameAvailable == false) {
      return 'Username is already taken';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required';
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 6) {
      return 'Minimum 6 characters';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (!isLogin && value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF1E293B),
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFF87171),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF1E293B),
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFF34D399),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  void _toggleMode() {
    if (loading) return;

    setState(() {
      isLogin = !isLogin;
      usernameAvailable = null;
      checkingUsername = false;
      _usernameTimer?.cancel();

      _usernameController.clear();
      _confirmPasswordController.clear();
      _formKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final wide = size.width >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFF070A12),
      body: Stack(
        children: [
          const _Background(),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: wide ? 48 : 20,
                  vertical: 28,
                ),
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeOut,
                  ),
                  child: wide
                      ? _desktopLayout()
                      : _mobileLayout(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopLayout() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1120),
      child: Row(
        children: [
          Expanded(
            child: _hero(),
          ),
          const SizedBox(width: 80),
          SizedBox(
            width: 430,
            child: _authPanel(),
          ),
        ],
      ),
    );
  }

  Widget _mobileLayout() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 470),
      child: _authPanel(),
    );
  }

  Widget _hero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _brandMark(size: 72),

        const SizedBox(height: 28),

        const Text(
          'Arab.it',
          style: TextStyle(
            color: Colors.white,
            fontSize: 52,
            fontWeight: FontWeight.w900,
            letterSpacing: -2.5,
          ),
        ),

        const SizedBox(height: 14),

        const Text(
          'Learn languages.\nBuild confidence.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            height: 1.08,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.3,
          ),
        ),

        const SizedBox(height: 18),

        const SizedBox(
          width: 520,
          child: Text(
            'A modern language learning experience for English, '
            'Italiano and العربية.',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ),

        const SizedBox(height: 34),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            _LanguageChip(
              flag: '🇬🇧',
              text: 'English',
            ),
            _LanguageChip(
              flag: '🇮🇹',
              text: 'Italiano',
            ),
            _LanguageChip(
              flag: '🇸🇦',
              text: 'العربية',
            ),
          ],
        ),

        const SizedBox(height: 34),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.045),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.07),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: Color(0xFF8B5CF6),
                size: 22,
              ),
              SizedBox(width: 12),
              Text(
                'Interactive lessons + AI Coach',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _authPanel() {
    return Column(
      children: [
        _brandMark(size: 62),

        const SizedBox(height: 18),

        const Text(
          'Arab.it',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 7),

        Text(
          isLogin
              ? 'Welcome back'
              : 'Create your account',
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 24),

        _card(),

        const SizedBox(height: 18),

        _modeSwitch(),

        const SizedBox(height: 14),

        const Text(
          'English  •  Italiano  •  العربية',
          style: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _brandMark({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * .28),
        gradient: AppGradients.brand,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: .25),
            blurRadius: 28,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size - 8,
          height: size - 8,
          decoration: BoxDecoration(
            color: const Color(0xFF090D17),
            borderRadius: BorderRadius.circular(size * .23),
          ),
          child: Center(
            child: Text(
              'A',
              style: TextStyle(
                color: Colors.white,
                fontSize: size * .42,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _card() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF101624),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withValues(alpha: .07),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .30),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: AppGradients.brand,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isLogin
                        ? Icons.login_rounded
                        : Icons.person_add_alt_1_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isLogin
                        ? 'Sign in to continue'
                        : 'Start learning today',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            if (!isLogin) ...[
              _usernameField(),
              const SizedBox(height: 16),
            ],

            _field(
              controller: _emailController,
              label: 'Email',
              hint: 'you@example.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),

            const SizedBox(height: 16),

            _passwordField(
              controller: _passwordController,
              label: 'Password',
              obscure: obscurePassword,
              onToggle: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              validator: _validatePassword,
            ),

            if (!isLogin) ...[
              const SizedBox(height: 16),
              _passwordField(
                controller: _confirmPasswordController,
                label: 'Confirm password',
                obscure: obscureConfirmPassword,
                onToggle: () {
                  setState(() {
                    obscureConfirmPassword =
                        !obscureConfirmPassword;
                  });
                },
                validator: _validateConfirmPassword,
              ),
            ],

            if (isLogin)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: loading ? null : _forgotPassword,
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: Color(0xFFA78BFA),
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              )
            else
              const SizedBox(height: 8),

            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _usernameField() {
    Color statusColor = const Color(0xFF64748B);
    IconData statusIcon = Icons.person_outline_rounded;

    if (checkingUsername) {
      statusIcon = Icons.sync_rounded;
    } else if (usernameAvailable == true) {
      statusColor = const Color(0xFF34D399);
      statusIcon = Icons.check_circle_rounded;
    } else if (usernameAvailable == false) {
      statusColor = const Color(0xFFF87171);
      statusIcon = Icons.cancel_rounded;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Username'),

        const SizedBox(height: 7),

        TextFormField(
          controller: _usernameController,
          validator: _validateUsername,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          textCapitalization: TextCapitalization.none,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          decoration: _decoration(
            hint: 'your_username',
            icon: Icons.alternate_email_rounded,
          ).copyWith(
            prefixText: '@',
            prefixStyle: const TextStyle(
              color: Color(0xFFA78BFA),
              fontWeight: FontWeight.w900,
            ),
            suffixIcon: Icon(
              statusIcon,
              color: statusColor,
              size: 19,
            ),
          ),
        ),

        const SizedBox(height: 7),

        Row(
          children: [
            Icon(
              usernameAvailable == true
                  ? Icons.check_rounded
                  : Icons.info_outline_rounded,
              size: 13,
              color: statusColor,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                checkingUsername
                    ? 'Checking username...'
                    : usernameAvailable == true
                        ? 'Username is available'
                        : '3–20 characters · letters, numbers and _',
                style: TextStyle(
                  color: statusColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
          decoration: _decoration(
            hint: hint,
            icon: icon,
          ),
        ),
      ],
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          validator: validator,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
          decoration: _decoration(
            hint: 'Enter your password',
            icon: Icons.lock_outline_rounded,
          ).copyWith(
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF64748B),
                size: 19,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFFE2E8F0),
        fontSize: 11,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  InputDecoration _decoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF475569),
        fontSize: 12,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF64748B),
        size: 19,
      ),
      filled: true,
      fillColor: const Color(0xFF0B111D),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: .05),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: .06),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFF8B5CF6),
          width: 1.4,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFF87171),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFF87171),
          width: 1.4,
        ),
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppGradients.brand,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6).withValues(alpha: .20),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: loading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: loading
              ? const SizedBox(
                  width: 21,
                  height: 21,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLogin
                          ? 'Sign in'
                          : 'Create account',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _modeSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin
              ? "Don't have an account?"
              : 'Already have an account?',
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 11,
          ),
        ),
        TextButton(
          onPressed: loading ? null : _toggleMode,
          child: Text(
            isLogin ? 'Create account' : 'Sign in',
            style: const TextStyle(
              color: Color(0xFFA78BFA),
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String flag;
  final String text;

  const _LanguageChip({
    required this.flag,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .045),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(alpha: .07),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            flag,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF070A12),
                    Color(0xFF090D17),
                    Color(0xFF070A12),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: -170,
            right: -120,
            child: _glow(
              const Color(0xFF7C3AED),
              430,
            ),
          ),

          Positioned(
            bottom: -190,
            left: -160,
            child: _glow(
              AppColors.cyan,
              470,
            ),
          ),
        ],
      ),
    );
  }

  Widget _glow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: .16),
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}










