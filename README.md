# Flutter Rating Bar

[![pub package](https://img.shields.io/badge/pub-v1.1.0-green.svg)](https://pub.dartlang.org/packages/flutter_rating_bar)  [![licence](https://img.shields.io/badge/Licence-MIT-orange.svg)](https://github.com/sarbagyastha/flutter_rating_bar/blob/master/LICENSE)

A simple yet fully customizable ratingbar for flutter which also include a rating bar indicator, supporting any fraction of rating.

![DEMO](rating_demo.gif) 

## Usage

#### 1\. Depend

Add this to you package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_rating_bar: ^1.1.0
```

#### 2\. Install

Run command:

```bash
$ flutter packages get
```

#### 3\. Import

Import in Dart code:

```dart
import 'package:flutter_rating_bar/flutter_rating_bar';
```

#### 4\. Using Flutter Rating Bar

```dart
FlutterRatingBar(
      initialRating: 3,
      fillColor: Colors.amber,
      borderColor: Colors.amber.withAlpha(50),
      allowHalfRating: true,
      onRatingUpdate: (rating) {
           print(rating);
      },
),
```

#### 5\. Using Flutter Rating Bar Indicator

```dart
FlutterRatingBarIndicator(
     rating: 2.75,
     itemCount: 5,
     itemSize: 50.0,
     emptyColor: Colors.amber.withAlpha(50),
),
```

In order to make the indicator scrollable, just use 'physics' property as in the [example](https://github.com/sarbagyastha/flutter_rating_bar/blob/master/example/lib/main.dart).

## Customize Rating Bar
```dart
FlutterRatingBarIndicator(
    rating: _userRating,
    pathClipper: DiamondClipper(),
    itemCount: 5,
    itemSize: 50.0,
    emptyColor: Colors.amber.withAlpha(50),
),

class DiamondClipper extends CustomClipper<Path> {...}
```

## Customize Rating Bar Indicator
```dart
FlutterRatingBar(
     initialRating: 2.87,
     allowHalfRating: true,
     itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
     fullRatingWidget: _image("assets/heart.png") ,
     halfRatingWidget: _image("assets/heart_half.png"),
     noRatingWidget: _image("assets/heart_border.png"),
     onRatingUpdate: (rating) {
         print(rating);
     },
),

Widget _image(String asset) {
    return Image.asset(
      asset,
      height: 30.0,
      width: 30.0,
      color: Colors.amber,
    );
}
```

Heart Icons are [Available Here](https://github.com/sarbagyastha/flutter_rating_bar/tree/master/example/assets).

## After Customization
![CUSTOM DEMO](custom_example.png) 

## License

```
Copyright (c) 2019 Sarbagya Dhaubanjar

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```