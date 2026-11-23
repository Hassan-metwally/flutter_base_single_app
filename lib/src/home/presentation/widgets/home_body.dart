part of '../home_page.dart';

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  Future<void> Function()? _refreshAds;
  Future<void> _onRefresh() {
    return Future.wait([_refreshAds?.call() ?? Future<void>.value()]);
  }

  void _bindAds(Future<void> Function()? refresh) => _refreshAds = refresh;

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      color: AppColors.backgroundColor,
      backgroundColor: AppColors.primary,
      onRefresh: _onRefresh,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: AdsWidget(onBindRefresh: _bindAds)),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
