import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_routes.dart';
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

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _loginErrorMessage;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_clearLoginError);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_clearLoginError);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearLoginError() {
    if (_loginErrorMessage != null) {
      setState(() => _loginErrorMessage = null);
    }
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            LoginSubmitted(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  String? _loginErrorForDisplay(AuthFailure state, AppLocalizations l10n) {
    final msg = state.message.toUpperCase();
    if (msg.contains('INVALID_CREDENTIALS') || msg.contains('INVALID CREDENTIALS')) {
      return l10n.invalidCredentials;
    }
    return state.message;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.go(AppRoutes.home);
        } else if (state is AuthFailure) {
          setState(() {
            _loginErrorMessage = _loginErrorForDisplay(state, l10n);
          });
        } else if (state is AuthLoading) {
          setState(() => _loginErrorMessage = null);
        }
      },
      child: Scaffold(
        body: AuthBackground(
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Lottie.asset(
                        AppAssets.animations.loading,
                        fit: BoxFit.contain,
                        repeat: true,
                      ),
                    ),
                  ),
                  const AuthLogo(size: 90),
                  const SizedBox(height: 32),
                  AuthHeader(
                    title: l10n.login,
                    subtitle: 'Kullanıcı bilgilerinle giriş yap',
                  ),
                  const SizedBox(height: 36),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
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
                          errorText: _loginErrorMessage,
                          validator: (v) {
                            if (_loginErrorMessage != null) return null;
                            if (v == null || v.isEmpty) return l10n.passwordRequired;
                            if (v.length < 6) return l10n.passwordTooShort;
                            return null;
                          },
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              l10n.forgotPassword,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'InstrumentSans',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return AuthButton(
                              label: l10n.signInButton,
                              isLoading: state is AuthLoading,
                              onPressed: () => _submit(context),
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
                    promptText: 'Bir hesabın yok mu? ',
                    linkText: 'Kayıt Ol',
                    onLinkTap: () => context.go(AppRoutes.register),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
