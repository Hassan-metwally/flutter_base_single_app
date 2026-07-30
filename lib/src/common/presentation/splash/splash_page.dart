import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/config/values/assets.gen.dart';
import '../../../../core/core.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _animationController;

  /// Invoked when the splash screen's delay is completed.
  ///
  /// This method adds an [AppStartedEvent] to the [AppAuthenticationBloc],
  /// notifying the app that the splash screen is finished and the user can be
  /// authenticated.
  void _onSplashComplete() {
    AppAuthenticationBloc.of(context).add(const AppStartedEvent());
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _onSplashComplete();
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            controller: _animationController,
            onLoaded: (lottie) {
              _animationController.duration = lottie.duration;
              _animationController.forward();
            },
            repeat: false,
            Assets.animations.azhimny,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
