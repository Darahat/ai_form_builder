import 'dart:async';

import 'package:ai_chat/core/widgets/scaffold_messenger.dart';
import 'package:ai_chat/features/auth/application/auth_state.dart';
import 'package:ai_chat/features/auth/provider/auth_providers.dart';
import 'package:ai_chat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

/// Input OTP Presentation page
class OTPPage extends ConsumerStatefulWidget {
  /// input OTP presentation page controller
  const OTPPage({super.key});

  @override
  ConsumerState<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends ConsumerState<OTPPage> {
  final pinController = TextEditingController();
  Timer? _timer;
  int _start = 240; // 4 minutes
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _isResendEnabled = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isResendEnabled = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(authControllerProvider.notifier);
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState is AuthLoading;

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next is AuthError) {
        scaffoldMessenger(context, next);
      }
      if (next is Authenticated) {
        context.go('/home');
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.enterOTP)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                AppLocalizations.of(context)!.enterTheOTPSentToYourPhone,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Pinput(
                controller: pinController,
                length: 6,
                onCompleted: (pin) {
                  controller.verifyOTP(pin);
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            controller.verifyOTP(pinController.text);
                          },
                  child:
                      isLoading
                          ? const CircularProgressIndicator()
                          : Text(AppLocalizations.of(context)!.verifyOTP),
                ),
              ),
              const SizedBox(height: 24),
              if (_isResendEnabled)
                TextButton(
                  onPressed: () {
                    controller.resendOTP();
                    setState(() {
                      _start = 240;
                    });
                    startTimer();
                  },
                  child: Text(AppLocalizations.of(context)!.resendOTP),
                )
              else
                Text(
                  '${AppLocalizations.of(context)!.resendOTPIn}$_start seconds',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
