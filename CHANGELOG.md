## 3.0.0+2
* **FIXED** `unratedColor` not working for colors with alpha [Issue #15](https://github.com/sarbagyastha/flutter_rating_bar/issues/15).

## 3.0.0+1
* **FIXED** Issue with scrollable views [Issue #18](https://github.com/sarbagyastha/flutter_rating_bar/issues/18).
* **FIXED** `unratedColor` not working for colors with alpha [Issue #15](https://github.com/sarbagyastha/flutter_rating_bar/issues/15).

## 3.0.0
**Breaking Changes**
This version requires `flutter >= 1.9`.

* Removed `alpha` property, as alpha vale can be provided directly with `unratedColor`.
* Adjusted some default behaviours for size and unratedColor.
* **FIXED** Issue while using RatingWidget in RTL mode.
* Improved dart docs

## 2.0.0+2
* **Fixed** Issue with `unratedColor` being null. [Issue #13 & #14](https://github.com/sarbagyastha/flutter_rating_bar/issues/13)
* **Fixed** `alpha` property behaving in opposite manner.

## 2.0.0+1
* Added `unratedColor` property. [Issue #12](https://github.com/sarbagyastha/flutter_rating_bar/issues/12)

## 2.0.0
**Breaking Changes**

* `FlutterRatingBar` is renamed to `RatingBar` and `FlutterRatingBarIndicator` to `RatingBarIndicator`.
* `itemBuilder` is introduced. Now you can use any widget as items with Rating Bar.  
* Improved RTL Mode.
* Vertical Mode.
* Glow while rating.

## 1.3.0+1
* **FIXED** Rating Indicator not switching to RTL mode.

## 1.3.0
* **FEATURE ADDED** Added Support for RTL Mode [Issue #5](https://github.com/sarbagyastha/flutter_rating_bar/issues/5)
* **FIXED** Fixed issue with allowHalfRating [Issue #6](https://github.com/sarbagyastha/flutter_rating_bar/issues/6)


## 1.2.0
* **FIXED** [Issue #2](https://github.com/sarbagyastha/flutter_rating_bar/issues/2).

## 1.1.0

* [ignoreGestures](https://pub.dartlang.org/documentation/flutter_rating_bar/latest/flutter_rating_bar/FlutterRatingBar/ignoreGestures.html) property added to FlutterRatingBar as per [#1](https://github.com/sarbagyastha/flutter_rating_bar/issues/1) by @Skquark.
* [tapOnlyMode](https://pub.dartlang.org/documentation/flutter_rating_bar/latest/flutter_rating_bar/FlutterRatingBar/tapOnlyMode.html) property added to FlutterRatingBar.
* Readme updated with customization images and links to api docs.

## 1.1.0

* FlutterRatingBar is also fully customizable as Indicator now.
* Readme updated with customization examples.
* Dart-complaint docs added.
* [Breaking Change] size property in FlutterRatingBar is changed to itemSize for the sake of consistency.

## 1.0.0

* Initial release
