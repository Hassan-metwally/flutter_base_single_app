import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/core.dart';
import '../../material/change_language/change_language_bottom_sheet.dart';
import '../../material/media/app_image.dart';
import '../../material/media/svg_icon.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentPage = 0;
  final List<Widget> _imagesWidgets = [AppImages.providerOnboarding1, AppImages.providerOnboarding2, AppImages.providerOnboarding3]
      .map(
        (item) => Center(
          child: AppImage(path: item, height: 325, width: 267, cacheImage: true, fit: BoxFit.contain),
        ),
      )
      .toList();
  List<Widget> get _titleWidgets => [
    appLocalizer.providerOnBoardingTitle1,
    appLocalizer.providerOnBoardingTitle2,
    appLocalizer.providerOnBoardingTitle3,
  ].map((item) => _TitleWidget(text: item)).toList();
  List<Widget> get _subTitleWidgets => [
    appLocalizer.providerOnBoardingSubTitle1,
    appLocalizer.providerOnBoardingSubTitle2,
    appLocalizer.providerOnBoardingSubTitle3,
  ].map((item) => _SubTitleWidget(text: item)).toList();

  int get _kOnbordingPageCount => _imagesWidgets.length;
  bool get getIsLastPage => _currentPage == _kOnbordingPageCount - 1;
  bool get getIsFirstPage => _currentPage == 0;

  void _onNext() {
    if (getIsLastPage) {
      _onFinish();
    } else {
      setState(() {
        _currentPage++;
      });
    }
  }

  // void _onPrevious() {
  //   if (!getIsFirstPage) {
  //     setState(() {
  //       _currentPage--;
  //     });
  //   }
  // }

  void _onFinish() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    AppAuthenticationBloc.of(context).add(const OnFinishWalkThrowEvent());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                CustomPaint(size: const Size(double.infinity, 525), painter: RPSCustomPainter()),
                AnimatedSwitcher(
                  duration: Durations.medium2,
                  reverseDuration: Durations.medium4,
                  child: Center(
                    child: SizedBox(height: 500, key: ValueKey(_currentPage), child: _imagesWidgets[_currentPage]),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _HeaderWidget(onSkip: _onFinish, canSkip: !getIsLastPage),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _PageProgressInductor(currentPage: _currentPage, count: _kOnbordingPageCount),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: AnimatedSwitcher(duration: Durations.medium4, reverseDuration: Durations.medium4, child: _titleWidgets[_currentPage]),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: AnimatedSwitcher(duration: Durations.medium4, reverseDuration: Durations.medium4, child: _subTitleWidgets[_currentPage]),
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: _ThreeStepButton(step: _currentPage, totalSteps: _kOnbordingPageCount, onTap: _onNext),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _PageProgressInductor extends StatelessWidget {
  const _PageProgressInductor({required this.currentPage, required this.count});
  final int currentPage;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: currentPage == 0 ? MainAxisAlignment.center : MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final bool isSelected = index == currentPage;
        return AnimatedContainer(
          duration: Durations.medium2,
          height: 8,
          width: isSelected ? 30 : 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: isSelected ? AppColors.primary500 : AppColors.black200),
        );
      }),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({required this.onSkip, required this.canSkip});

  final VoidCallback onSkip;
  final bool canSkip;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        (canSkip)
            ? GestureDetector(
                onTap: onSkip,
                behavior: HitTestBehavior.opaque,
                child: Text(appLocalizer.skip, style: TextStyles.light16.copyWith(color: Colors.black)),
              )
            : const SizedBox(),
        GestureDetector(
          onTap: () {
            ChangeLanguageBottomSheet.show(context);
          },
          behavior: HitTestBehavior.opaque,
          child: Row(
            spacing: 4,
            children: [
              AppSvgIcon(path: "", color: AppColors.primary),
              BlocBuilder<AppLanguageCubit, AppLanguageState>(
                builder: (context, state) {
                  return Text(appLocalizer.languageName, style: TextStyles.light16.copyWith(color: Colors.black));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyles.regular18.copyWith(color: AppColors.textColor),
    );
  }
}

class _SubTitleWidget extends StatelessWidget {
  const _SubTitleWidget({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyles.regular14.copyWith(color: AppColors.black600),
      maxLines: 3,
    );
  }
}

class _ThreeStepButton extends StatelessWidget {
  const _ThreeStepButton({required this.step, required this.totalSteps, required this.onTap});

  final int step;
  final int totalSteps;
  final VoidCallback onTap;

  bool get isLast => step == totalSteps - 1;

  @override
  Widget build(BuildContext context) {
    final List<String> labels = [appLocalizer.next, appLocalizer.next, appLocalizer.startNow];
    final String label = labels[step.clamp(0, labels.length - 1)];

    final double screenWidth = MediaQuery.of(context).size.width;

    // Animate between 1/3, 2/3, and full width
    final double targetWidth = switch (step) {
      0 => screenWidth / 3 - 30,
      1 => (screenWidth / 3) * 2 - 40,
      _ => screenWidth - 40,
    };

    return GestureDetector(
      onTap: onTap,
      onHorizontalDragUpdate: (_) => onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 58,
            decoration: BoxDecoration(color: AppColors.primary50, borderRadius: BorderRadius.circular(12)),
          ),
          Positioned.directional(
            start: 0,
            textDirection: Directionality.of(context),
            child: AnimatedContainer(
              padding: const EdgeInsetsDirectional.only(start: 20),
              duration: Durations.medium4,
              curve: Curves.easeInOut,
              width: targetWidth,
              height: 58,
              decoration: BoxDecoration(color: AppColors.primary500, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [Text(label, style: TextStyles.semiBold16.copyWith(color: Colors.white))],
              ),
            ),
          ),

          Positioned.directional(
            end: 0,
            textDirection: Directionality.of(context),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: Icon(Icons.arrow_forward_ios_sharp, color: isLast ? Colors.white : AppColors.textColor, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Path path_0 = Path();
    path_0.moveTo(size.width * 1.029333, size.height * 0.8554659);
    path_0.cubicTo(
      size.width * 1.029333,
      size.height * 0.8554659,
      size.width * 0.9533040,
      size.height * 0.8497407,
      size.width * 0.9056107,
      size.height * 0.8554659,
    );
    path_0.cubicTo(
      size.width * 0.8594053,
      size.height * 0.8610136,
      size.width * 0.8326053,
      size.height * 0.8662320,
      size.width * 0.7917067,
      size.height * 0.8830819,
    );
    path_0.cubicTo(
      size.width * 0.7404960,
      size.height * 0.9041793,
      size.width * 0.7313360,
      size.height * 0.9355634,
      size.width * 0.6817307,
      size.height * 0.9586628,
    );
    path_0.cubicTo(
      size.width * 0.6556027,
      size.height * 0.9708304,
      size.width * 0.6401600,
      size.height * 0.9772651,
      size.width * 0.6110293,
      size.height * 0.9848265,
    );
    path_0.cubicTo(
      size.width * 0.5721253,
      size.height * 0.9949240,
      size.width * 0.5481680,
      size.height * 0.9973177,
      size.width * 0.5069467,
      size.height * 0.9979064,
    );
    path_0.cubicTo(
      size.width * 0.4604240,
      size.height * 0.9985731,
      size.width * 0.4324507,
      size.height * 0.9973645,
      size.width * 0.3891147,
      size.height * 0.9848265,
    );
    path_0.cubicTo(
      size.width * 0.3538293,
      size.height * 0.9746179,
      size.width * 0.3366400,
      size.height * 0.9641481,
      size.width * 0.3066320,
      size.height * 0.9470351,
    );
    path_0.cubicTo(
      size.width * 0.2688293,
      size.height * 0.9254776,
      size.width * 0.2607451,
      size.height * 0.9017368,
      size.width * 0.2202219,
      size.height * 0.8830819,
    );
    path_0.cubicTo(
      size.width * 0.1847789,
      size.height * 0.8667661,
      size.width * 0.1609445,
      size.height * 0.8617057,
      size.width * 0.1200648,
      size.height * 0.8554659,
    );
    path_0.cubicTo(
      size.width * 0.06598320,
      size.height * 0.8472125,
      size.width * -0.02133333,
      size.height * 0.8554659,
      size.width * -0.02133333,
      size.height * 0.8554659,
    );
    path_0.lineTo(size.width * -0.02133333, size.height * -0.02534113);
    path_0.lineTo(size.width * 1.029333, size.height * -0.02534113);
    path_0.lineTo(size.width * 1.029333, size.height * 0.8554659);
    path_0.close();

    final Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.primary500
      ..strokeJoin = StrokeJoin.bevel
      ..strokeCap = StrokeCap.round;
    // canvas.drawPath(path_0, paint0Stroke);

    final Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = AppColors.primary50;
    canvas.drawPath(path_0, paint0Fill);

    // Define the spacing for the dots
    const double dashWidth = 4.0; // width of each dot
    const double dashSpace = 6.0; // space between dots

    // Iterate over the path
    for (final PathMetric pathMetric in path_0.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        const double currentDashLength = dashWidth;
        final Path extractPath = pathMetric.extractPath(distance, distance + currentDashLength);
        canvas.drawPath(extractPath, paint0Stroke);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
