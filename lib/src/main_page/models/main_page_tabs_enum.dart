import '../../../core/core.dart';

enum MainPageTabsEnum {
  home,
  orders,
  cart,
  more;

  String get filledIc {
    switch (this) {
      case MainPageTabsEnum.home:
        return "";
      case MainPageTabsEnum.orders:
        return "";
      case MainPageTabsEnum.cart:
        return "";
      case MainPageTabsEnum.more:
        return "";
    }
  }

  String get outlineIc {
    switch (this) {
      case MainPageTabsEnum.home:
        return "";
      case MainPageTabsEnum.orders:
        return "";
      case MainPageTabsEnum.cart:
        return "";
      case MainPageTabsEnum.more:
        return "";
    }
  }

  String get title {
    switch (this) {
      case MainPageTabsEnum.home:
        return appLocalizer.home;
      case MainPageTabsEnum.orders:
        return appLocalizer.orders;
      case MainPageTabsEnum.cart:
        return appLocalizer.cart;
      case MainPageTabsEnum.more:
        return appLocalizer.more;
    }
  }
}
