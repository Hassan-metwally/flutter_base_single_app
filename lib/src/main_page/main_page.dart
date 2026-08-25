import 'dart:io';

import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/core.dart';
import '../../material/auth_states/guest_checker_widget.dart';
import '../../material/auth_states/unauthenticated_bottom_sheet.dart';
import '../../material/media/svg_icon.dart';
import '../../material/offstage.dart';
import '../notifications/helpers/firebase/firebase_helper.dart';
import '../home/presentation/home_page.dart';
import '../more/presentation/more_page/more_page.dart';
import 'models/main_page_tabs_enum.dart';
import 'observer/main_page_observer.dart';

part 'widgets/bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with MainPageObserverMixin {
  MainPageTabsEnum _currentTabEnum = MainPageTabsEnum.home;
  final List<MainPageTabsEnum> _loadedPages = [MainPageTabsEnum.home];

  void _addUnAuthenticatedListener() {
    UnAuthenticatedInterceptor.instance.addListener(() {
      UnAuthenticatedBottomSheet.show();
    });
  }

  void _onCurrentTapChanged(MainPageTabsEnum currentTap) {
    if (!_loadedPages.contains(currentTap)) {
      _loadedPages.add(currentTap);
    }
    _currentTabEnum = currentTap;

    setState(() {});
  }

  void _onPop() {
    if (_currentTabEnum != MainPageTabsEnum.home) {
      _onCurrentTapChanged(MainPageTabsEnum.home);
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  void initState() {
    FirebaseHelper.setUpNotificationListener();
    initObserver(onTabChanged: _onCurrentTapChanged);
    _addUnAuthenticatedListener();
    super.initState();
    // _getUnReadNotificationsCount();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   DeepLinksUtils.intit();
    // });
  }

  // void _getUnReadNotificationsCount() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (AppAuthenticationBloc.of(context).state is AuthAuthenticatedState) {
  //       context.read<NotificationsCubit>().getUnreadNotificationCount();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (_, _) {
          _onPop();
        },
        child: IndexedStack(
          index: _currentTabEnum.index,
          children: [
            OffStage(isActive: _currentTabEnum == MainPageTabsEnum.home, child: HomePage()),
            OffStage(
              isActive: _currentTabEnum == MainPageTabsEnum.orders,
              child: const GuestCheckerWidget(replaceWithDefaultGuestWidget: true, child: SizedBox()),
            ),
            OffStage(
              isActive: _currentTabEnum == MainPageTabsEnum.cart,
              child: const GuestCheckerWidget(replaceWithDefaultGuestWidget: true, child: SizedBox()),
            ),
            OffStage(isActive: _currentTabEnum == MainPageTabsEnum.more, child: const MorePage()),
          ],
        ),
      ),
      bottomNavigationBar: _ClientBottomNavigationBar(selctedTab: _currentTabEnum, onTabChanged: _onCurrentTapChanged),
    );
  }

  @override
  void dispose() {
    super.dispose();
    UnAuthenticatedInterceptor.instance.dispose();
  }
}
