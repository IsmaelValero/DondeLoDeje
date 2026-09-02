import 'package:flutter/material.dart';

import '../data/user_session.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../widgets/user_avatar.dart';

/// Pantalla de bienvenida para registrar el nombre la primera vez.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const screenKey = ValueKey<String>('onboarding_screen');

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canContinue => _controller.text.trim().isNotEmpty;

  void _continuar() {
    final nombre = _controller.text.trim();
    if (nombre.isEmpty) return;

    UserSession.instance.completeOnboarding(nombre);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final nombre = _controller.text;

    return Scaffold(
      key: OnboardingScreen.screenKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            AppSpacing.xxl,
            AppSpacing.screenHorizontal,
            AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: UserAvatar(
                  name: nombre,
                  size: 96,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Donde',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      height: 1.08,
                      letterSpacing: -0.8,
                      color: palette.textPrimary,
                    ),
                  ),
                  Text(
                    'Lo',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      height: 1.08,
                      letterSpacing: -0.8,
                      color: palette.terracotta,
                    ),
                  ),
                  Text(
                    'Deje',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      height: 1.08,
                      letterSpacing: -0.8,
                      color: palette.petrol,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Recuerda dónde dejaste tus cosas',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: palette.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              Text(
                '¿Cómo te llamas?',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                key: const Key('campo_nombre_onboarding'),
                controller: _controller,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (_canContinue) _continuar();
                },
                decoration: const InputDecoration(
                  hintText: 'Tu nombre',
                ),
              ),
              const Spacer(),
              FilledButton(
                key: const Key('btn_empezar_onboarding'),
                onPressed: _canContinue ? _continuar : null,
                child: const Text('Empezar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
