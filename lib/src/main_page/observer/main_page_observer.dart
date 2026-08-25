import 'package:flutter/material.dart';

import '../models/main_page_tabs_enum.dart';

part "main_page_mixin.dart";
part 'main_page_updater.dart';

class MainPageObserver<MainPageTabsEnum> {
  final void Function(MainPageTabsEnum tab)? onTabChanged;

  MainPageObserver({this.onTabChanged}) {
    MainPageUpdater.instance.attachObserver(this);
  }

  void dispose() {
    MainPageUpdater.instance.deAttachObserver(this);
  }

  void notifyOnChangedCallbacks(MainPageTabsEnum tab) {
    if (onTabChanged != null) {
      onTabChanged!(tab);
    }
  }
}
