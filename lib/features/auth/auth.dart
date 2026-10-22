import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../state/app_state.dart';
import '../../ui/widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, box) => SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: box.maxHeight * .57,
                child: Center(
                  child: Stack(
                    children: [
                      const AssetImageView(
                        'welcome-3d',
                        width: 285,
                        height: 303,
                      ),
                      const Positioned(
                        top: 45,
                        right: 4,
                        child: Text(
                          '3D Design',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Palette.light,
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _WelcomeCard(
                            'Become a Seller',
                            'welcome-seller',
                            () {
                              AppScope.of(context).setSeller(true);
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/',
                                (_) => false,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _WelcomeCard(
                            'Find a Services',
                            'welcome-buyer',
                            () {
                              AppScope.of(context).setSeller(false);
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/',
                                (_) => false,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => go(context, '/login'),
                          child: const Text('Sign In'),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (_) => false,
                          ),
                          child: const Text('Skip'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard(this.title, this.image, this.onTap);
  final String title, image;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        AssetImageView(image, height: 130, width: double.infinity),
        Container(
          color: Palette.background,
          height: 46,
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Palette.accent,
            ),
          ),
        ),
      ],
    ),
  );
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.signup = false});
  final bool signup;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController(),
      password = TextEditingController(),
      name = TextEditingController();
  bool visible = false;
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: widget.signup ? 'Sign Up' : 'Sign In',
    child: Form(
      key: form,
      child: Column(
        children: [
          if (widget.signup)
            LabelField(
              'Full Name',
              controller: name,
              hint: 'Your full name',
              validator: requiredText,
            ),
          LabelField(
            'Email Address or Username',
            controller: email,
            hint: 'Your email address or username',
            validator: requiredText,
          ),
          LabelField(
            'Password',
            controller: password,
            hint: 'Your password',
            obscure: !visible,
            validator: (v) =>
                v == null || v.length < 6 ? 'Use at least 6 characters' : null,
            suffix: IconButton(
              tooltip: 'Show password',
              onPressed: () => setState(() => visible = !visible),
              icon: Icon(
                visible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                size: 20,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              if (!form.currentState!.validate()) return;
              AppScope.of(context)
                  .signIn(widget.signup ? name.text.trim() : 'Emma Barocathun');
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            },
            child: Text(widget.signup ? 'Create Account' : 'Sign In'),
          ),
          const SizedBox(height: 10),
          if (!widget.signup)
            TextButton(
              onPressed: () => go(context, '/reset'),
              child: const Text('Forgot Password?'),
            ),
          TextButton(
            onPressed: () => go(context, widget.signup ? '/login' : '/signup'),
            child: Text(
              widget.signup
                  ? 'Already have an account? Sign In'
                  : 'New to Pixelz? Sign Up',
            ),
          ),
          const SizedBox(height: 70),
          const Text(
            'Demo account · Any username and a password of 6+ characters. No credentials are stored.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Palette.muted),
          ),
          const SizedBox(height: 40),
          const Text(
            'By joining, you agree to our',
            style: TextStyle(color: Palette.muted),
          ),
          TextButton(
            onPressed: () => go(context, '/info', 'Terms of Services'),
            child: const Text('Terms and Conditions'),
          ),
        ],
      ),
    ),
  );
}

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController(),
      pin = TextEditingController(),
      password = TextEditingController();
  int step = 0;
  @override
  void dispose() {
    email.dispose();
    pin.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageFrame(
    title: [
      'Forgot Password',
      'Confirm Email',
      'New Password',
      'Password Updated',
    ][step],
    child: step == 3
        ? EmptyView(
            'You’re all set',
            'The demo reset flow is complete. Sign in to continue.',
            icon: CupertinoIcons.checkmark_seal_fill,
            action: FilledButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Sign In'),
            ),
          )
        : Form(
            key: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  [
                    'Let’s get you back in.',
                    'Check your verification code.',
                    'Choose your new password.',
                  ][step],
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 25),
                if (step == 0)
                  LabelField(
                    'Email Address',
                    controller: email,
                    hint: 'you@example.com',
                    validator: (v) =>
                        v == null ||
                            !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)
                        ? 'Enter a valid email address'
                        : null,
                  ),
                if (step == 1) ...[
                  const Text(
                    'Demo code: 1234. No email is sent.',
                    style: TextStyle(color: Palette.muted),
                  ),
                  const SizedBox(height: 20),
                  LabelField(
                    'Verification Code',
                    controller: pin,
                    number: true,
                    validator: (v) =>
                        v != '1234' ? 'Use the demo code 1234' : null,
                  ),
                ],
                if (step == 2)
                  LabelField(
                    'New Password',
                    controller: password,
                    obscure: true,
                    validator: (v) => v == null || v.length < 6
                        ? 'Use at least 6 characters'
                        : null,
                  ),
                FilledButton(
                  onPressed: () {
                    if (form.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      setState(() => step++);
                    }
                  },
                  child: Text(
                    step == 0
                        ? 'Continue'
                        : step == 1
                        ? 'Verify Code'
                        : 'Update Password',
                  ),
                ),
              ],
            ),
          ),
  );
}
