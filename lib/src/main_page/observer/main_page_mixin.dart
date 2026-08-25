part of 'main_page_observer.dart';

mixin MainPageObserverMixin<T extends StatefulWidget> on State<T> {
  MainPageObserver? mainPageObserver;

  void initObserver<E extends MainPageTabsEnum, K>({void Function(MainPageTabsEnum tab)? onTabChanged}) {
    mainPageObserver = MainPageObserver<MainPageTabsEnum>(onTabChanged: onTabChanged);
  }

  @override
  void dispose() {
    mainPageObserver?.dispose();
    super.dispose();
  }
}
