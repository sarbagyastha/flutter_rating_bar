import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _ratingController = TextEditingController();
  double _rating;
  double _userRating = 3.0;
  bool _customize = false;

  @override
  void initState() {
    _ratingController.text = "3.0";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.amber,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Rating Bar'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              Text(
                "Rating Bar",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              FlutterRatingBar(
                initialRating: 3,
                allowHalfRating: true,
                ignoreGestures: false,
                tapOnlyMode: false,
                itemCount: 6,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                fullRatingWidget:
                    _customize ? _image("assets/heart.png") : null,
                halfRatingWidget:
                    _customize ? _image("assets/heart_half.png") : null,
                noRatingWidget:
                    _customize ? _image("assets/heart_border.png") : null,
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              _rating != null
                  ? Text(
                      "Rating: $_rating",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : Container(),
              SizedBox(
                height: 40.0,
              ),
              Text(
                "Rating Indicator",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              FlutterRatingBarIndicator(
                rating: _userRating,
                pathClipper: _customize ? DiamondClipper() : null,
                itemCount: 5,
                itemSize: 50.0,
                emptyColor: Colors.amber.withAlpha(50),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: _ratingController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter rating",
                    labelText: "Enter rating",
                    suffixIcon: MaterialButton(
                      onPressed: () {
                        setState(() {
                          _userRating =
                              double.parse(_ratingController.text ?? "0.0");
                        });
                      },
                      child: Text("Rate"),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Text(
                "Scrollable Rating Indicator",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              FlutterRatingBarIndicator(
                rating: 8.2,
                itemCount: 20,
                itemSize: 30.0,
                physics: BouncingScrollPhysics(),
                emptyColor: Colors.amber.withAlpha(50),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Switch to custom example",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Switch(
                    value: _customize,
                    onChanged: (value) {
                      setState(() {
                        _customize = value;
                      });
                    },
                    activeColor: Colors.amber,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _image(String asset) {
    return Image.asset(
      asset,
      height: 30.0,
      width: 30.0,
      color: Colors.amber,
    );
  }
}

class DiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final len = size.width;
    path.lineTo(0, 1 / 4 * len);
    path.lineTo(1 / 4 * len, 0);
    path.lineTo(3 / 4 * len, 0);
    path.lineTo(len, 1 / 4 * len);
    path.lineTo(1 / 2 * len, len);
    path.lineTo(0, 1 / 4 * len);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
