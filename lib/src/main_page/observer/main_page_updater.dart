part of 'main_page_observer.dart';

class MainPageUpdater {
  MainPageUpdater._();

  static MainPageUpdater? _instance;

  static MainPageUpdater get instance {
    _instance ??= MainPageUpdater._();
    return _instance!;
  }

  final List<MainPageObserver> _observers = [];

  void attachObserver<T>(MainPageObserver observer) {
    _observers.add(observer);
  }

  void deAttachObserver(MainPageObserver observer) {
    _observers.remove(observer);
  }

  static void notifyOnChangedCallbacks(MainPageTabsEnum value) {
    for (var observer in instance._observers) {
      observer.notifyOnChangedCallbacks(value);
    }
  }

  static void dispose() {
    _instance?._observers.clear();
    _instance = null;
  }
}
