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
                fillColor: Colors.amber,
                borderColor: Colors.amber.withAlpha(50),
                allowHalfRating: true,
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
            ],
          ),
        ),
      ),
    );
  }
}
