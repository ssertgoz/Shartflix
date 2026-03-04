import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auth_background.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_link_prompt.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_social_buttons.dart';
import '../widgets/auth_text_field.dart';
import 'package:shartflix/l10n/app_localizations.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).termsRequired),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            RegisterSubmitted(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              name: _nameController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.registerSuccess),
              backgroundColor: AppColors.success,
            ),
          );
          NavigationService.go(AppRoutes.photoUpload);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        body: AuthBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const AuthLogo(),
                  AuthHeader(
                    title: l10n.createAccount,
                    subtitle: l10n.registerSubtitle,
                  ),
                  const SizedBox(height: 36),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthTextField(
                          controller: _nameController,
                          label: l10n.name,
                          hint: l10n.nameHint,
                          keyboardType: TextInputType.name,
                          prefixIconPath: AppAssets.icons.user,
                          validator: (v) {
                            if (v == null || v.isEmpty) return l10n.nameRequired;
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        AuthTextField(
                          controller: _emailController,
                          label: l10n.email,
                          hint: l10n.emailHint,
                          keyboardType: TextInputType.emailAddress,
                          prefixIconPath: AppAssets.icons.mail,
                          validator: (v) {
                            if (v == null || v.isEmpty) return l10n.emailRequired;
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                              return l10n.emailInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        AuthTextField(
                          controller: _passwordController,
                          label: l10n.password,
                          hint: l10n.passwordHint,
                          isPassword: true,
                          prefixIconPath: AppAssets.icons.lock,
                          validator: (v) {
                            if (v == null || v.isEmpty) return l10n.passwordRequired;
                            if (v.length < 6) return l10n.passwordTooShort;
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        AuthTextField(
                          controller: _confirmPasswordController,
                          label: l10n.confirmPassword,
                          hint: l10n.confirmPasswordHint,
                          isPassword: true,
                          prefixIconPath: AppAssets.icons.lock,
                          validator: (v) {
                            if (v == null || v.isEmpty) return l10n.passwordRequired;
                            if (v != _passwordController.text) {
                              return l10n.passwordMismatch;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTermsCheckbox(context, l10n),
                        const SizedBox(height: 28),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return AuthButton(
                              label: l10n.signUpButton,
                              isLoading: state is AuthLoading,
                              onPressed: _agreedToTerms ? () => _submit(context) : null,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const AuthSocialButtons(),
                  const SizedBox(height: 24),
                  AuthLinkPrompt(
                    promptText: '${l10n.hasAccountPrompt} ',
                    linkText: l10n.loginLinkText,
                    onLinkTap: () => NavigationService.go(AppRoutes.login),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox(BuildContext context, AppLocalizations l10n) {
    const grayStyle = TextStyle(
      color: AppColors.textSecondary,
      fontSize: 12,
      height: 1.35,
      fontFamily: 'InstrumentSans',
    );
    const linkStyle = TextStyle(
      color: AppColors.textPrimary,
      fontSize: 13,
      height: 1.35,
      fontWeight: FontWeight.w600,
      fontFamily: 'InstrumentSans',
      decoration: TextDecoration.underline,
      decorationColor: AppColors.textPrimary,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 1.35,
          child: Checkbox(
            value: _agreedToTerms,
            onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
            activeColor: AppColors.primary,
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primary;
              }
              return AppColors.inputBackground;
            }),
            checkColor: AppColors.white,
            side: BorderSide(color: AppColors.inputBorder),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RichText(
              text: TextSpan(
                style: grayStyle,
                children: [
                  TextSpan(text: l10n.termsPrefix),
                  TextSpan(
                    text: l10n.termsLink,
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => setState(() => _agreedToTerms = !_agreedToTerms),
                  ),
                  const TextSpan(text: '\n'),
                  TextSpan(text: l10n.termsSuffix),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
