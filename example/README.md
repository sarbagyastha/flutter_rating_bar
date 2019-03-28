# flutter_rating_bar_example

[More Detailed Example](https://github.com/sarbagyastha/flutter_rating_bar/blob/master/example/lib/main.dart)


#### Using Flutter Rating Bar

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

#### Using Flutter Rating Bar Indicator

```dart
FlutterRatingBarIndicator(
     rating: 2.75,
     itemCount: 5,
     itemSize: 50.0,
     emptyColor: Colors.amber.withAlpha(50),
),
```