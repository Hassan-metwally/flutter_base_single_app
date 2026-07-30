import '../../../../../core/core.dart';

enum StaticPageTypeEnum {
  aboutUs,
  termsAndConditions,
  privacyPolicy;

  String get title {
    switch (this) {
      case StaticPageTypeEnum.aboutUs:
        return appLocalizer.aboutApp;
      case StaticPageTypeEnum.termsAndConditions:
        return appLocalizer.termsAndConditions;
      case StaticPageTypeEnum.privacyPolicy:
        return appLocalizer.privacyPolicy;
    }
  }

  String get key {
    switch (this) {
      case StaticPageTypeEnum.aboutUs:
        return "about-app";
      case StaticPageTypeEnum.termsAndConditions:
        return "terms-and-conditions";
      case StaticPageTypeEnum.privacyPolicy:
        return "privacy-policy";
    }
  }
}
