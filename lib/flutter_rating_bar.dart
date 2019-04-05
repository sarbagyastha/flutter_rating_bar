import 'package:flutter/material.dart';

typedef RatingCallback(double rating);

class FlutterRatingBarIndicator extends StatefulWidget {
  ///[rating] takes the rating value for indicator. if [rating]==null value defaults to 0.0
  final double rating;

  ///[itemCount] is the count of rating bar items.
  final int itemCount;

  /// [itemSize] of each rating item in the bar.
  final double itemSize;

  /// [itemPadding] gives padding to each rating item.
  final EdgeInsets itemPadding;

  /// [fillColor] fills the rating indicator on rated part.
  final Color fillColor;

  /// [physics] controls the scrolling behaviour of rating bar. Default is [NeverScrollableScrollPhysics].
  final ScrollPhysics physics;

  /// [emptyColor] fills the rating indicator on unrated part.
  final Color emptyColor;

  /// [pathClipper] takes CustomClipper to generate custom-shapes for rating items.
  final CustomClipper<Path> pathClipper;

  FlutterRatingBarIndicator({
    this.rating = 0.0,
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
  ///[itemCount] is the count of rating bar items.
  final int itemCount;

  ///[initialRating] is initial rating to be set to the rating bar.
  final double initialRating;

  ///[onRatingUpdate] is a callback which return current rating.
  final RatingCallback onRatingUpdate;

  ///[fillColor] colors [halfRatingWidget] and [fullRatingWidget].
  final Color fillColor;

  /// [borderColor] colors the [noRatingWidget].
  final Color borderColor;

  /// [itemSize] of each rating item in the bar.
  final double itemSize;

  ///Default [allowHalfRating] = false. Setting true enables half rating support.
  final bool allowHalfRating;

  ///[fullRatingWidget] denotes the full rating status. Default is Icon(Icons.star).
  final Widget fullRatingWidget;

  ///[halfRatingWidget] denotes the half rating status. Default is Icon(Icons.star_half).
  final Widget halfRatingWidget;

  ///[noRatingWidget] denotes the full rating status. Default is Icon(Icons.star_border).
  final Widget noRatingWidget;

  /// [itemPadding] gives padding to each rating item.
  final EdgeInsets itemPadding;

  /// [ignoreGestures]=false, if set to true will disable any gestures over the rating bar.
  final bool ignoreGestures;

  /// [tapOnlyMode]=false, if set to true will disable drag to rate feature. Note: Enabling this mode will disable half rating capability.
  final bool tapOnlyMode;

  FlutterRatingBar({
    this.itemCount = 5,
    this.initialRating = 0.0,
    @required this.onRatingUpdate,
    this.fillColor = Colors.amber,
    this.borderColor,
    this.itemSize = 40.0,
    this.allowHalfRating = false,
    this.fullRatingWidget,
    this.halfRatingWidget,
    this.noRatingWidget,
    this.itemPadding = const EdgeInsets.all(0.0),
    this.ignoreGestures = false,
    this.tapOnlyMode = false,
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
            return _buildRating(context, index);
          },
        ),
      ),
    );
  }

  Widget _buildRating(BuildContext context, int index) {
    Widget ratingWidget;
    if (index >= _rating) {
      ratingWidget = widget.noRatingWidget ??
          Icon(
            Icons.star_border,
            color: widget.borderColor ?? Colors.amber.withAlpha(100),
            size: widget.itemSize ?? 25.0,
          );
    } else if (index > _rating - (widget.allowHalfRating ? 0.5 : 1.0) &&
        index < _rating) {
      ratingWidget = widget.halfRatingWidget ??
          Icon(
            Icons.star_half,
            color: widget.fillColor,
            size: widget.itemSize ?? 25.0,
          );
      iconRating += 0.5;
    } else {
      ratingWidget = widget.fullRatingWidget ??
          Icon(
            Icons.star,
            color: widget.fillColor,
            size: widget.itemSize ?? 25.0,
          );
      iconRating += 1.0;
    }

    return IgnorePointer(
      ignoring: widget.ignoreGestures,
      child: GestureDetector(
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
          if (!widget.tapOnlyMode) {
            RenderBox box = context.findRenderObject();
            var _pos = box.globalToLocal(dragDetails.globalPosition);
            var i = _pos.dx / widget.itemSize;
            var currentRating =
                widget.allowHalfRating ? i : i.round().toDouble();
            if (currentRating > widget.itemCount) {
              currentRating = widget.itemCount.toDouble();
            }
            if (currentRating < 0) {
              currentRating = 0.0;
            }
            if (widget.onRatingUpdate != null) {
              setState(() {
                _rating = currentRating;
              });
            }
          }
        },
        child: Padding(
          padding: widget.itemPadding,
          child: ratingWidget,
        ),
      ),
    );
  }
}
