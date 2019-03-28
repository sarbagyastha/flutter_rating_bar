import 'package:flutter/material.dart';

typedef RatingCallback(double rating);

class FlutterRatingBarIndicator extends StatefulWidget {
  final double rating;
  final int itemCount;
  final double itemSize;
  final EdgeInsets itemPadding;
  final Color fillColor;
  final ScrollPhysics physics;
  final Color emptyColor;
  final CustomClipper<Path> pathClipper;

  FlutterRatingBarIndicator({
    this.rating = 3.27,
    this.itemCount = 5,
    this.itemSize = 30.0,
    this.itemPadding = const EdgeInsets.all(4.0),
    this.fillColor = Colors.amber,
    this.emptyColor = Colors.white,
    this.physics = const NeverScrollableScrollPhysics(),
    this.pathClipper,
  });

  @override
  _FlutterRatingBarIndicatorState createState() =>
      _FlutterRatingBarIndicatorState();
}

class _FlutterRatingBarIndicatorState extends State<FlutterRatingBarIndicator> {
  double _ratingFraction = 0.0;
  int _ratingNumber = 0;

  @override
  void initState() {
    super.initState();
    _ratingNumber = widget.rating.truncate() + 1;
    _ratingFraction = (widget.rating - _ratingNumber + 1) * widget.itemSize;
  }

  @override
  Widget build(BuildContext context) {
    _ratingNumber = widget.rating.truncate() + 1;
    _ratingFraction = (widget.rating - _ratingNumber + 1) * widget.itemSize;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: widget.physics,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          widget.itemCount,
          (index) {
            return Padding(
              padding: widget.itemPadding,
              child: ClipPath(
                clipper: widget.pathClipper ?? StarClipper(),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  height: widget.itemSize,
                  width: widget.itemSize,
                  child: index + 1 > _ratingNumber
                      ? Container(
                          color: widget.emptyColor,
                          width: widget.itemSize,
                          height: widget.itemSize,
                        )
                      : Row(
                          children: <Widget>[
                            Container(
                              height: widget.itemSize,
                              width: index + 1 == _ratingNumber
                                  ? _ratingFraction
                                  : widget.itemSize,
                              color: widget.fillColor,
                            ),
                            Expanded(
                              child: Container(
                                height: widget.itemSize,
                                color: widget.emptyColor,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class StarClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    final path = Path();
    final len = size.width;
    path.lineTo(0, len);
    path.lineTo(1 / 5 * len, len);
    path.lineTo(1 / 2 * len, 0);
    path.lineTo(4 / 5 * len, len);
    path.lineTo(0, 2 / 5 * len);
    path.lineTo(len, 2 / 5 * len);
    path.lineTo(1 / 5 * len, len);
    path.lineTo(0, len);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class FlutterRatingBar extends StatefulWidget {
  final int itemCount;
  final double initialRating;
  final RatingCallback onRatingUpdate;
  final Color fillColor;
  final Color borderColor;
  final double size;
  final bool allowHalfRating;

  FlutterRatingBar({
    this.itemCount = 5,
    this.initialRating = 0.0,
    @required this.onRatingUpdate,
    this.fillColor = Colors.amber,
    this.borderColor,
    this.size = 40.0,
    this.allowHalfRating = false,
  });

  @override
  _FlutterRatingBarState createState() => _FlutterRatingBarState();
}

class _FlutterRatingBarState extends State<FlutterRatingBar> {
  double _rating = 0.0;
  double _ratingHistory = 0.0;
  double iconRating = 0.0;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
    _ratingHistory = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    if (_ratingHistory != widget.initialRating) {
      _rating = widget.initialRating;
      _ratingHistory = widget.initialRating;
    }
    iconRating = 0.0;
    return Material(
      color: Colors.transparent,
      child: Wrap(
        alignment: WrapAlignment.start,
        children: List.generate(
          widget.itemCount,
          (index) {
            return buildStar(context, index);
          },
        ),
      ),
    );
  }

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= _rating) {
      icon = Icon(
        Icons.star_border,
        color: widget.borderColor ?? Theme.of(context).primaryColor,
        size: widget.size ?? 25.0,
      );
    } else if (index > _rating - (widget.allowHalfRating ? 0.5 : 1.0) &&
        index < _rating) {
      icon = Icon(
        Icons.star_half,
        color: widget.fillColor ?? Theme.of(context).primaryColor,
        size: widget.size ?? 25.0,
      );
      iconRating += 0.5;
    } else {
      icon = Icon(
        Icons.star,
        color: widget.fillColor ?? Theme.of(context).primaryColor,
        size: widget.size ?? 25.0,
      );
      iconRating += 1.0;
    }

    return GestureDetector(
      onTap: () {
        if (widget.onRatingUpdate != null) {
          widget.onRatingUpdate(index + 1.0);
          setState(() {
            _rating = index + 1.0;
          });
        }
      },
      onHorizontalDragEnd: (_) {
        widget.onRatingUpdate(iconRating);
        iconRating = 0.0;
      },
      onHorizontalDragUpdate: (dragDetails) {
        RenderBox box = context.findRenderObject();
        var _pos = box.globalToLocal(dragDetails.globalPosition);
        var i = _pos.dx / widget.size;
        var newRating = widget.allowHalfRating ? i : i.round().toDouble();
        if (newRating > widget.itemCount) {
          newRating = widget.itemCount.toDouble();
        }
        if (newRating < 0) {
          newRating = 0.0;
        }
        if (widget.onRatingUpdate != null) {
          setState(() {
            _rating = newRating;
          });
        }
      },
      child: icon,
    );
  }
}
