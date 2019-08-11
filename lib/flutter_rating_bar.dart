import 'package:flutter/material.dart';

class RatingWidget {
  final Widget full;
  final Widget half;
  final Widget empty;

  RatingWidget({
    @required this.full,
    @required this.half,
    @required this.empty,
  });
}

class _HalfRatingWidget extends StatelessWidget {
  final Widget child;
  final double size;
  final int alpha;
  final bool enableMask;
  final bool rtlMode;
  final Color unratedColor;

  _HalfRatingWidget({
    this.size,
    this.child,
    this.alpha,
    this.enableMask = true,
    this.rtlMode = false,
    this.unratedColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: enableMask
          ? Stack(
              fit: StackFit.expand,
              children: [
                FittedBox(
                  fit: BoxFit.contain,
                  child: _NoRatingWidget(
                    child: child,
                    size: size,
                    alpha: alpha,
                    unratedColor: unratedColor,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: ClipRect(
                    clipper: _HalfClipper(
                      rtlMode: rtlMode,
                    ),
                    child: child,
                  ),
                ),
              ],
            )
          : FittedBox(
              child: child,
              fit: BoxFit.contain,
            ),
    );
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  final bool rtlMode;

  _HalfClipper({
    this.rtlMode = false,
  });

  @override
  Rect getClip(Size size) => rtlMode
      ? Rect.fromLTRB(
          size.width / 2,
          0.0,
          size.width,
          size.height,
        )
      : Rect.fromLTRB(
          0.0,
          0.0,
          size.width / 2,
          size.height,
        );

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}

class _NoRatingWidget extends StatelessWidget {
  final double size;
  final Widget child;
  final int alpha;
  final bool enableMask;
  final Color unratedColor;

  _NoRatingWidget({
    this.size,
    this.child,
    this.alpha,
    this.enableMask = true,
    this.unratedColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: FittedBox(
        fit: BoxFit.contain,
        child: enableMask
            ? _ColorMask(
                color: unratedColor.withAlpha(alpha),
                child: child,
              )
            : child,
      ),
    );
  }
}

class _ColorMask extends StatelessWidget {
  final Color color;
  final Widget child;

  _ColorMask({
    Key key,
    this.color,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(colors: [
        color,
        color,
      ]).createShader(bounds),
      blendMode: BlendMode.srcATop,
      child: child,
    );
  }
}

class _IndicatorClipper extends CustomClipper<Rect> {
  final double ratingFraction;
  final bool rtlMode;

  _IndicatorClipper({
    this.ratingFraction,
    this.rtlMode = false,
  });

  @override
  Rect getClip(Size size) => rtlMode
      ? Rect.fromLTRB(
          size.width - size.width * ratingFraction,
          0.0,
          size.width,
          size.height,
        )
      : Rect.fromLTRB(
          0.0,
          0.0,
          size.width * ratingFraction,
          size.height,
        );

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}

class RatingBarIndicator extends StatefulWidget {
  ///[rating] takes the rating value for indicator. if [rating]==null value.
  ///
  /// Default = 0.0
  final double rating;

  ///[itemCount] is the count of rating bar items.
  ///
  /// Default = 5
  final int itemCount;

  /// [itemSize] of each rating item in the bar.
  ///
  /// Default = 30.0
  final double itemSize;

  /// [itemPadding] gives padding to each rating item.
  ///
  /// Default = EdgeInsets.all(4.0)
  final EdgeInsets itemPadding;

  /// [physics] controls the scrolling behaviour of rating bar.
  ///
  /// Default is [NeverScrollableScrollPhysics].
  final ScrollPhysics physics;

  /// The text flows from right to left if [textDirection] = TextDirection.rtl
  final TextDirection textDirection;

  /// Defines the color opacity for unrated portion.
  ///
  /// Default = 80
  final int alpha;

  /// Widget for each rating bar indicator item.
  final IndexedWidgetBuilder itemBuilder;

  /// Direction or rating bar indicator. Either can be vertical or horizontal.
  ///
  /// Default = Axis.horizontal
  final Axis direction;

  /// Defines color for the unrated portion.
  final Color unratedColor;

  RatingBarIndicator({
    @required this.itemBuilder,
    this.rating = 0.0,
    this.itemCount = 5,
    this.itemSize = 30.0,
    this.itemPadding = const EdgeInsets.all(4.0),
    this.physics = const NeverScrollableScrollPhysics(),
    this.textDirection,
    this.alpha = 80,
    this.direction = Axis.horizontal,
    this.unratedColor = Colors.white,
  });

  @override
  _RatingBarIndicatorState createState() => _RatingBarIndicatorState();
}

class _RatingBarIndicatorState extends State<RatingBarIndicator> {
  double _ratingFraction = 0.0;
  int _ratingNumber = 0;
  bool _isRTL = false;

  @override
  void initState() {
    super.initState();
    _ratingNumber = widget.rating.truncate() + 1;
    _ratingFraction = widget.rating - _ratingNumber + 1;
  }

  @override
  Widget build(BuildContext context) {
    _isRTL = (widget.textDirection ?? Directionality.of(context)) ==
        TextDirection.rtl;
    _ratingNumber = widget.rating.truncate() + 1;
    _ratingFraction = widget.rating - _ratingNumber + 1;
    return SingleChildScrollView(
      scrollDirection: widget.direction,
      physics: widget.physics,
      child: widget.direction == Axis.horizontal
          ? Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
              children: _children(),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
              children: _children(),
            ),
    );
  }

  List<Widget> _children() {
    return List.generate(
      widget.itemCount,
      (index) {
        if (widget.textDirection != null) {
          if (widget.textDirection == TextDirection.rtl &&
              Directionality.of(context) != TextDirection.rtl) {
            return Transform(
              transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
              alignment: Alignment.center,
              transformHitTests: false,
              child: _buildItems(index),
            );
          }
        }
        return _buildItems(index);
      },
    );
  }

  Widget _buildItems(int index) => Padding(
        padding: widget.itemPadding,
        child: SizedBox(
          width: widget.itemSize,
          height: widget.itemSize,
          child: Stack(
            fit: StackFit.expand,
            children: [
              FittedBox(
                fit: BoxFit.contain,
                child: index + 1 < _ratingNumber
                    ? widget.itemBuilder(context, index)
                    : _ColorMask(
                        color: widget.unratedColor.withAlpha(widget.alpha),
                        child: widget.itemBuilder(context, index),
                      ),
              ),
              if (index + 1 == _ratingNumber)
                _isRTL
                    ? FittedBox(
                        fit: BoxFit.contain,
                        child: ClipRect(
                          clipper: _IndicatorClipper(
                            ratingFraction: _ratingFraction,
                            rtlMode: _isRTL,
                          ),
                          child: widget.itemBuilder(context, index),
                        ),
                      )
                    : FittedBox(
                        fit: BoxFit.contain,
                        child: ClipRect(
                          clipper: _IndicatorClipper(
                            ratingFraction: _ratingFraction,
                          ),
                          child: widget.itemBuilder(context, index),
                        ),
                      ),
            ],
          ),
        ),
      );
}

class RatingBar extends StatefulWidget {
  ///[itemCount] is the count of rating bar items.
  final int itemCount;

  ///[initialRating] is initial rating to be set to the rating bar.
  final double initialRating;

  ///[onRatingUpdate] is a callback which return current rating.
  final ValueChanged<double> onRatingUpdate;

  /// [itemSize] of each rating item in the bar.
  final double itemSize;

  ///Default [allowHalfRating] = false. Setting true enables half rating support.
  final bool allowHalfRating;

  /// [itemPadding] gives padding to each rating item.
  final EdgeInsets itemPadding;

  /// [ignoreGestures]=false, if set to true will disable any gestures over the rating bar.
  final bool ignoreGestures;

  /// [tapOnlyMode]=false, if set to true will disable drag to rate feature. Note: Enabling this mode will disable half rating capability.
  final bool tapOnlyMode;

  /// The text flows from right to left if [textDirection] = TextDirection.rtl
  final TextDirection textDirection;

  /// Widget for each rating bar indicator item.
  final IndexedWidgetBuilder itemBuilder;

  /// Defines the color opacity for unrated portion.
  ///
  /// Default = 80
  final int alpha;

  /// Customizes the Rating Bar item with [RatingWidget].
  final RatingWidget ratingWidget;

  /// if set to true, Rating Bar item will glow ehen being touched.
  ///
  /// Default = true
  final bool glow;

  /// Defines the radius of glow.
  ///
  /// Default = 2
  final double glowRadius;

  /// Defines color for glow.
  ///
  /// Default = theme's accent color
  final Color glowColor;

  /// Direction or rating bar indicator. Either can be vertical or horizontal.
  ///
  /// Default = Axis.horizontal
  final Axis direction;

  /// Defines color for unrated portion.
  final Color unratedColor;

  RatingBar({
    this.itemCount = 5,
    this.initialRating = 0.0,
    @required this.onRatingUpdate,
    this.alpha = 80,
    this.itemSize = 40.0,
    this.allowHalfRating = false,
    this.itemBuilder,
    this.itemPadding = const EdgeInsets.all(0.0),
    this.ignoreGestures = false,
    this.tapOnlyMode = false,
    this.textDirection,
    this.ratingWidget,
    this.glow = true,
    this.glowRadius = 2,
    this.direction = Axis.horizontal,
    this.glowColor,
    this.unratedColor,
  }) : assert(
          (itemBuilder == null && ratingWidget != null) ||
              (itemBuilder != null && ratingWidget == null),
          'itemBuilder and ratingWidget can\'t be initialized at the same time. Either remove ratingWidget or itembuilder.',
        );

  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  double _rating = 0.0;
  double _ratingHistory = 0.0;
  double iconRating = 0.0;
  bool _isRTL = false;
  ValueNotifier<bool> _glow = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
    _ratingHistory = widget.initialRating;
  }

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isRTL = (widget.textDirection ?? Directionality.of(context)) ==
        TextDirection.rtl;
    if (_ratingHistory != widget.initialRating) {
      _rating = widget.initialRating;
      _ratingHistory = widget.initialRating;
    }
    iconRating = 0.0;
    return Material(
      color: Colors.transparent,
      child: Wrap(
        alignment: WrapAlignment.start,
        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
        direction: widget.direction,
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
      ratingWidget = _NoRatingWidget(
        size: widget.itemSize,
        child: widget.ratingWidget?.empty ?? widget.itemBuilder(context, index),
        enableMask: widget.ratingWidget == null,
        alpha: widget.alpha,
        unratedColor: widget.unratedColor,
      );
    } else if (index >= _rating - (widget.allowHalfRating ? 0.5 : 1.0) &&
        index < _rating &&
        widget.allowHalfRating) {
      ratingWidget = _HalfRatingWidget(
        size: widget.itemSize,
        child: widget.ratingWidget?.half ?? widget.itemBuilder(context, index),
        enableMask: widget.ratingWidget == null,
        alpha: widget.alpha,
        rtlMode: _isRTL,
        unratedColor: widget.unratedColor,
      );
      iconRating += 0.5;
    } else {
      ratingWidget = SizedBox(
        width: widget.itemSize,
        height: widget.itemSize,
        child: FittedBox(
          fit: BoxFit.contain,
          child:
              widget.ratingWidget?.full ?? widget.itemBuilder(context, index),
        ),
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
        onHorizontalDragStart: (_) {
          if (widget.direction == Axis.horizontal) _glow.value = true;
        },
        onHorizontalDragEnd: (_) {
          if (widget.direction == Axis.horizontal) {
            _glow.value = false;
            widget.onRatingUpdate(iconRating);
            iconRating = 0.0;
          }
        },
        onHorizontalDragUpdate: (dragUpdates) {
          if (widget.direction == Axis.horizontal)
            _dragOperation(dragUpdates, widget.direction);
        },
        onVerticalDragStart: (_) {
          if (widget.direction == Axis.vertical) _glow.value = true;
        },
        onVerticalDragEnd: (_) {
          if (widget.direction == Axis.vertical) {
            _glow.value = false;
            widget.onRatingUpdate(iconRating);
            iconRating = 0.0;
          }
        },
        onVerticalDragUpdate: (dragUpdates) {
          if (widget.direction == Axis.vertical)
            _dragOperation(dragUpdates, widget.direction);
        },
        child: Padding(
          padding: widget.itemPadding,
          child: ValueListenableBuilder(
            valueListenable: _glow,
            builder: (context, glow, _) {
              if (glow && widget.glow) {
                Color glowColor =
                    widget.glowColor ?? Theme.of(context).accentColor;
                return DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: glowColor.withAlpha(30),
                        blurRadius: 10,
                        spreadRadius: widget.glowRadius,
                      ),
                      BoxShadow(
                        color: glowColor.withAlpha(20),
                        blurRadius: 10,
                        spreadRadius: widget.glowRadius,
                      ),
                    ],
                  ),
                  child: ratingWidget,
                );
              } else {
                return ratingWidget;
              }
            },
          ),
        ),
      ),
    );
  }

  void _dragOperation(DragUpdateDetails dragDetails, Axis direction) {
    if (!widget.tapOnlyMode) {
      RenderBox box = context.findRenderObject();
      var _pos = box.globalToLocal(dragDetails.globalPosition);
      double i;
      if (direction == Axis.horizontal) {
        i = _pos.dx / (widget.itemSize + widget.itemPadding.horizontal);
      } else {
        i = _pos.dy / (widget.itemSize + widget.itemPadding.vertical);
      }
      var currentRating = widget.allowHalfRating ? i : i.round().toDouble();
      if (currentRating > widget.itemCount) {
        currentRating = widget.itemCount.toDouble();
      }
      if (currentRating < 0) {
        currentRating = 0.0;
      }
      if (_isRTL && widget.direction == Axis.horizontal) {
        currentRating = widget.itemCount - currentRating;
      }
      if (widget.onRatingUpdate != null) {
        setState(() {
          _rating = currentRating;
        });
      }
    }
  }
}
