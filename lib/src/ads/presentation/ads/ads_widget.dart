import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/src/ads/presentation/ads/ads_cubit.dart';
import '../../../../core/di/di.dart';
import 'widgets/ads_slider_widget.dart';

class AdsWidget extends StatefulWidget {
  const AdsWidget({super.key, this.onBindRefresh});

  final void Function(Future<void> Function()? refresh)? onBindRefresh;

  @override
  State<AdsWidget> createState() => _AdsWidgetState();
}

class _AdsWidgetState extends State<AdsWidget> {
  late final AdsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = injector<AdsCubit>()..getAllAds();
    widget.onBindRefresh?.call(_cubit.getAllAds);
  }

  @override
  void dispose() {
    widget.onBindRefresh?.call(null);
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<AdsCubit, AdsState>(
        builder: (context, state) {
          if (state.getAllAdsState.isLoading) {
            return const AdsSliderLoadingWidget();
          } else if (state.getAllAdsState.isFailure) {
            return AdsSliderErrorWidget(
              onRetry: () {
                context.read<AdsCubit>().getAllAds();
              },
            );
          } else if (state.getAllAdsState.isSuccess) {
            final ads = state.getAllAdsState.data ?? [];
            return AdsSliderWidget(sliders: ads);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
