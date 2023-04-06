import 'dart:math';

import 'package:division/src/function/angle_to_radians.dart';
import 'package:division/src/model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum AngleFormat { degree, radians, cycles }

abstract class CoreStyle {
  CoreStyle({this.angleFormat = AngleFormat.cycles}) {
    _addListeners();
  }

  @mustCallSuper
  void _addListeners() {
    alignment.addListener(() => _styleModel.alignment = alignment.getAlignment);
    alignmentContent.addListener(
      () => _styleModel.alignmentContent = alignmentContent.getAlignment,
    );
    background.addListener(
      () => _styleModel
        ..backgroundColor = background.exportBackgroundColor
        ..backgroundBlur = background.exportBackgroundBlur
        ..backgroundImage = background.exportBackgroundImage
        ..backgroundBlendMode = background.exportBackgroundBlendMode,
    );
    overflow.addListener(
      () => _styleModel
        ..overflow = overflow.getOverflow
        ..overflowDirection = overflow.getDirection,
    );
  }

  final AngleFormat angleFormat;

  final StyleModel _styleModel = StyleModel();

  /// Alignment relative to its surroundings
  final AlignmentModel alignment = AlignmentModel();

  /// Alignment of the child
  final AlignmentModel alignmentContent = AlignmentModel();

  /// Widget background styling
  final BackgroundModel background = BackgroundModel();

  /// Change child overflow behaviour.
  /// ```dart
  /// ..overflow.visible(Axis.vertical) // overflows outside its parent
  /// ..overflow.hidden() // CLips to parent shape
  /// ..overflow.scrollable(Axis.vertical) // scrollable if bigger than parent
  /// ```
  final OverflowModel overflow = OverflowModel();

  /// Empty space to inscribe inside the [decoration]. The [child], if any, is placed inside this padding.
  ///
  /// All properties work together
  /// ```dart
  /// ..padding(all: 10, bottom: 20) // gives a different padding at the bottom
  /// ```
  void padding({
    final double? all,
    final double? horizontal,
    final double? vertical,
    final double? top,
    final double? bottom,
    final double? left,
    final double? right,
  }) {
    _styleModel.padding = EdgeInsets.only(
      top: top ?? vertical ?? all ?? 0.0,
      bottom: bottom ?? vertical ?? all ?? 0.0,
      left: left ?? horizontal ?? all ?? 0.0,
      right: right ?? horizontal ?? all ?? 0.0,
    );
  }

  /// Empty space to surround the [decoration] and [child].
  ///
  /// All properties work together
  /// ```dart
  /// ..margin(all: 10, bottom: 20) // gives a different margin at the bottom
  /// ```
  void margin({
    final double? all,
    final double? horizontal,
    final double? vertical,
    final double? top,
    final double? bottom,
    final double? left,
    final double? right,
  }) {
    _styleModel.margin = EdgeInsets.only(
      top: top ?? vertical ?? all ?? 0.0,
      bottom: bottom ?? vertical ?? all ?? 0.0,
      left: left ?? horizontal ?? all ?? 0.0,
      right: right ?? horizontal ?? all ?? 0.0,
    );
  }

  /// Creates a linear gradient.
  ///
  /// The [colors] argument must not be null. If [stops] is non-null, it must have the same length as [colors].
  void linearGradient({
    required final List<Color> colors,
    final AlignmentGeometry begin = Alignment.centerLeft,
    final AlignmentGeometry end = Alignment.centerRight,
    final TileMode tileMode = TileMode.clamp,
    final List<double>? stops,
  }) {
    _styleModel.gradient = LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
      tileMode: tileMode,
      stops: stops,
    );
  }

  /// Creates a radial gradient.
  ///
  /// The [colors] argument must not be null. If [stops] is non-null, it must have the same length as [colors].
  void radialGradient({
    required final double radius,
    required final List<Color> colors,
    final AlignmentGeometry center = Alignment.center,
    final TileMode tileMode = TileMode.clamp,
    final List<double>? stops,
  }) {
    _styleModel.gradient = RadialGradient(
      center: center,
      radius: radius,
      colors: colors,
      tileMode: tileMode,
      stops: stops,
    );
  }

  /// Creates a sweep gradient.
  ///
  /// The [colors] argument must not be null. If [stops] is non-null, it must have the same length as [colors].
  ///
  /// Choose to calculate angles with radians or not through [useRadians] parameter.
  /// [end] default to 1.0 if [useRadians] is false and 2 * pi if [useRadians] is true,
  void sweepGradient({
    required final double endAngle,
    required final List<Color> colors,
    final AlignmentGeometry center = Alignment.center,
    final double startAngle = 0.0,
    final TileMode tileMode = TileMode.clamp,
    final List<double>? stops,
  }) {
    _styleModel.gradient = SweepGradient(
      center: center,
      startAngle: angleToRadians(startAngle, angleFormat),
      endAngle: angleToRadians(endAngle, angleFormat),
      colors: colors,
      stops: stops,
      tileMode: tileMode,
    );
  }

  /// Border for the widget
  /// ```dart
  /// ..border(all: 3.0, color: hex('#55ffff'), style: BorderStyle.solid)
  /// ```
  /// Choose between `all`, `left`, `right`, `top` and `bottom`. `all` works together with the other properties.
  void border({
    final double? all,
    final double? left,
    final double? right,
    final double? top,
    final double? bottom,
    final Color color = const Color(0xFF000000),
    final BorderStyle style = BorderStyle.solid,
  }) {
    _styleModel.border = Border(
      left: (left ?? all) == null
          ? BorderSide.none
          : BorderSide(color: color, width: left ?? all!, style: style),
      right: (right ?? all) == null
          ? BorderSide.none
          : BorderSide(color: color, width: right ?? all!, style: style),
      top: (top ?? all) == null
          ? BorderSide.none
          : BorderSide(color: color, width: top ?? all!, style: style),
      bottom: (bottom ?? all) == null
          ? BorderSide.none
          : BorderSide(color: color, width: bottom ?? all!, style: style),
    );
  }

  /// It is valid to use `all` together with single sided properties. Single sided properties will trump over the `all` property.
  void borderRadius({
    final double? all,
    final double? topLeft,
    final double? topRight,
    final double? bottomLeft,
    final double? bottomRight,
  }) {
    _styleModel.borderRadius = BorderRadius.only(
      topLeft: Radius.circular(topLeft ?? all ?? 0.0),
      topRight: Radius.circular(topRight ?? all ?? 0.0),
      bottomLeft: Radius.circular(bottomLeft ?? all ?? 0.0),
      bottomRight: Radius.circular(bottomRight ?? all ?? 0.0),
    );
  }

  void circle([final bool enable = true]) =>
      enable ? _styleModel.boxShape = BoxShape.circle : null;

  // TODO: add posibility to append box shadow instead of replacing. bool append = true
  /// If defined while the elevation method is defined, the last one defined will be the one applied.
  void boxShadow({
    final Color color = const Color(0x33000000),
    final double blur = 0.0,
    final Offset offset = Offset.zero,
    final double spread = 0.0,
  }) =>
      _styleModel.boxShadow = <BoxShadow>[
        BoxShadow(
          color: color,
          blurRadius: blur,
          spreadRadius: spread,
          offset: offset,
        ),
      ];

  /// Elevates the widget with a boxShadow.
  /// [angle] format depends on what is specified in the style widget`s constructor.
  /// ```dart
  /// ..elevation(30.0, color: Colors.grey, angle: 0.0)
  /// ```
  void elevation(
    final double elevation, {
    final double angle = 0.0,
    final Color color = const Color(0x33000000),
    final double opacity = 1.0,
  }) {
    if (elevation == 0) {
      return;
    }

    final double newAngle = angleToRadians(angle, angleFormat);
    final double offsetX = sin(newAngle) * elevation;
    final double offsetY = cos(newAngle) * elevation;

    // custom curve defining the opacity
    double calculatedOpacity = (0.5 - (sqrt(elevation) / 19)) * opacity;
    if (calculatedOpacity < 0.0) {
      calculatedOpacity = 0.0;
    }

    final Color colorWithOpacity = color.withOpacity(calculatedOpacity);

    _styleModel.boxShadow = <BoxShadow>[
      BoxShadow(
        color: colorWithOpacity,
        blurRadius: elevation,
        offset: Offset(offsetX, offsetY),
      )
    ];
  }

  void width(final double width) => _styleModel.width = width;

  void minWidth(final double minWidth) => _styleModel.minWidth = minWidth;

  void maxWidth(final double maxWidth) => _styleModel.maxWidth = maxWidth;

  void height(final double height) => _styleModel.height = height;

  void minHeight(final double minHeight) => _styleModel.minHeight = minHeight;

  void maxHeight(final double maxHeight) => _styleModel.maxHeight = maxHeight;

  void scale(final double ratio) => _styleModel.scale = ratio;

  void offset(final double dx, final double dy) =>
      _styleModel.offset = Offset(dx, dy);

  ///
  /// ```dart
  /// StyleClass(angleFormat: AngleFormat.cycles)
  ///   ..rotate(0.75);
  ///
  /// StyleClass(angleFormat: AngleFormat.radians)
  ///   ..rotate(0.75 * pi * 2)
  /// ```
  void rotate(final double angle) =>
      _styleModel.rotate = angleToRadians(angle, angleFormat);

  void opacity(final double opacity) => _styleModel.opacity = opacity;

  /// Material ripple effect
  void ripple(
    final bool enable, {
    final Color? splashColor,
    final Color? highlightColor,
  }) {
    _styleModel.ripple = RippleModel(
      enable: enable,
      splashColor: splashColor,
      highlightColor: highlightColor,
    );
  }

  /// `Duration` is given in milliseconds.
  ///
  /// ```dart
  /// ..animate(400, Curves.easeInOut);
  /// ```
  ///
  /// **Adding a delay to your animation**
  /// ```
  /// .onTapDown((details) {
  ///   // change styling without a delay
  ///   thisStyle..backgroundColor(rgb(255,255,0));
  ///
  ///   // Trigger the setState with a delay
  ///   Future.delayed(Duration(milliseconds: 500)).then((_) => setState(() {}));
  /// })
  /// ```
  void animate([final int duration = 500, final Curve curve = Curves.linear]) =>
      _styleModel
        ..duration = Duration(milliseconds: duration)
        ..curve = curve;

  // void add<T extends CoreStyle>(T style, {bool override = false}) =>
  //   _styleModel?.inject(style?._styleModel, override);

  // export raw styledata
  StyleModel get exportStyle => _styleModel;
}

class ParentStyle extends CoreStyle {
  ParentStyle({super.angleFormat = AngleFormat.cycles});

  // TODO: implement
  // static ThemeDataModel<ParentStyle> themeData = ThemeDataModel<ParentStyle>();

  /// Combines style from another style instance
  /// ```dart
  /// ..add(ParentStyle()..width(100));
  /// ```
  void add(final ParentStyle parentStyle, {final bool override = false}) =>
      _styleModel.inject(parentStyle._styleModel, override);

  /// Clone object
  /// ```dart
  /// Parent(
  ///   'some text',
  ///   style: myStyle.clone()
  ///     ..width(100)
  ///     // etc..
  /// )
  /// ```
  ParentStyle clone() => ParentStyle(angleFormat: angleFormat)..add(this);
}

class TxtStyle extends CoreStyle {
  TxtStyle({super.angleFormat});

  @override
  void _addListeners() {
    super._addListeners();
    textAlign.addListener(() {
      _textModel.textAlign = textAlign.exportTextAlign;
    });
  }

  // TODO: implemet
  // static ThemeDataModel<TxtStyle> themeData = ThemeDataModel<TxtStyle>();

  final TextModel _textModel = TextModel();

  final TextAlignModel textAlign = TextAlignModel();

  void bold([final bool enable = true]) {
    if (enable) {
      _textModel.fontWeight = FontWeight.bold;
    }
  }

  void italic([final bool enable = true]) {
    if (enable) {
      _textModel.fontStyle = FontStyle.italic;
    }
  }

  void fontWeight(final FontWeight weight) => _textModel.fontWeight = weight;

  void fontSize(final double fontSize) => _textModel.fontSize = fontSize;

  void fontFamily(final String font, {final List<String>? fontFamilyFallback}) {
    _textModel.fontFamily = font;
    _textModel.fontFamilyFallback = fontFamilyFallback;
  }

  void textColor(final Color textColor) => _textModel.textColor = textColor;

  void maxLines(final int maxLines) => _textModel.maxLines = maxLines;

  void letterSpacing(final double space) => _textModel.letterSpacing = space;

  void wordSpacing(final double space) => _textModel.wordSpacing = space;

  void textDecoration(final TextDecoration decoration) =>
      _textModel.textDecoration = decoration;

  void textDirection(final TextDirection textDirection) =>
      _textModel.textDirection = textDirection;

  void textOverflow(final TextOverflow textOverflow) =>
      _textModel.textOverflow = textOverflow;

  void textShadow({
    final Color color = const Color(0x33000000),
    final double blur = 0.0,
    final Offset offset = Offset.zero,
  }) {
    _textModel.textShadow = <Shadow>[
      Shadow(
        color: color,
        blurRadius: blur,
        offset: offset,
      ),
    ];
  }

  /// Elevates the text with a shadow.
  /// [angle] format depends on what is specified in the style widget`s constructor.
  /// ```dart
  /// ..textElevation(30.0, color: Colors.grey, angle: 0.0)
  /// ```
  void textElevation(
    final double elevation, {
    final double angle = 0.0,
    final Color color = const Color(0x33000000),
    final double opacity = 1.0,
  }) {
    if (elevation == 0) {
      return;
    }

    final double newAngle = angleToRadians(angle, angleFormat);
    final double offsetX = sin(newAngle) * elevation;
    final double offsetY = cos(newAngle) * elevation;

    // custom curve defining the opacity
    double calculatedOpacity = (0.5 - (sqrt(elevation) / 19)) * opacity;
    if (calculatedOpacity < 0.0) {
      calculatedOpacity = 0.0;
    }

    final Color colorWithOpacity = color.withOpacity(calculatedOpacity);

    _textModel.textShadow = <Shadow>[
      Shadow(
        color: colorWithOpacity,
        blurRadius: elevation,
        offset: Offset(offsetX, offsetY),
      )
    ];
  }

  /// Make the widget editable just like a TextField.
  ///
  /// If `focusNode` isnt spesified an internal `focusNode` will be initiated.
  void editable({
    final bool enable = true,
    final TextInputType? keyboardType,
    final String? placeholder,
    final bool obscureText = false,
    final bool autoFocus = false,
    final int? maxLines,
    final void Function(String)? onChange,
    final void Function(bool? focus)? onFocusChange,
    final void Function(TextSelection, SelectionChangedCause?)?
        onSelectionChanged,
    final void Function()? onEditingComplete,
    final FocusNode? focusNode,
  }) {
    if (enable) {
      _textModel
        ..editable = true
        ..keyboardType = keyboardType
        ..placeholder = placeholder
        ..obscureText = obscureText
        ..autoFocus = autoFocus
        ..maxLines = maxLines
        ..onChange = onChange
        ..onFocusChange = onFocusChange
        ..onSelectionChanged = onSelectionChanged
        ..onEditingComplete = onEditingComplete
        ..focusNode = focusNode;
    }
  }

  /// Combines style from another style instance
  /// ```dart
  /// ..add(TxtStyle()..width(100));
  /// ```
  void add(final TxtStyle? txtStyle, {final bool override = false}) {
    if (txtStyle != null) {
      _styleModel.inject(txtStyle._styleModel, override);
      _textModel.inject(txtStyle._textModel, override);
    }
  }

  /// Clone object
  /// ```dart
  /// Txt(
  ///   'some text',
  ///   style: myStyle.clone()
  ///     ..width(100)
  ///     // etc..
  /// )
  /// ```
  TxtStyle clone() => TxtStyle(angleFormat: angleFormat)..add(this);

  TextModel get exportTextStyle => _textModel;
}

class Gestures {
  /// Apply gestures to a Division widgets
  /// ```dart
  /// Parent(
  ///   gesture: Gestures()
  ///     ..onTap(() => print('Widget pressed!'))
  ///     ..onLongPress(() => print('Widget longpress)),
  ///   child: Text('Some text'),
  /// )
  /// ```
  Gestures({
    this.behavior,
    this.excludeFromSemantics = false,
    this.dragStartBehavior = DragStartBehavior.start,
  }) : gestureModel = GestureModel(
          behavior: behavior,
          excludeFromSemantics: excludeFromSemantics,
          dragStartBehavior: dragStartBehavior,
        );

  /// How this gesture detector should behave during hit testing.
  ///
  /// This defaults to [HitTestBehavior.deferToChild] if [child] is not null and
  /// [HitTestBehavior.translucent] if child is null.
  final HitTestBehavior? behavior;

  /// Whether to exclude these gestures from the semantics tree. For
  /// example, the long-press gesture for showing a tooltip is
  /// excluded because the tooltip itself is included in the semantics
  /// tree directly and so having a gesture to show it would result in
  /// duplication of information.
  final bool excludeFromSemantics;

  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], gesture drag behavior will
  /// begin upon the detection of a drag gesture. If set to
  /// [DragStartBehavior.down] it will begin when a down event is first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.start].
  ///
  /// Only the [onStart] callbacks for the [VerticalDragGestureRecognizer],
  /// [HorizontalDragGestureRecognizer] and [PanGestureRecognizer] are affected
  /// by this setting.
  ///
  /// See also:
  ///
  ///  * [DragGestureRecognizer.dragStartBehavior], which gives an example for the different behaviors.
  final DragStartBehavior dragStartBehavior;

  final GestureModel gestureModel;

  /// Called whenever the tap state on the widget changes.
  ///
  /// This changes this
  /// ```dart
  /// ..onTapDown((_) => setState(() => pressed = true))
  /// ..onTapUp((_) => setState(() => pressed = false))
  /// ..onTapCancel(() => setState(() => pressed = false))
  /// ```
  /// to this
  /// ```dart
  /// ..isTap((isTapped) => setState(() => pressed = isTapped))
  /// ```
  void isTap(final void Function(bool) function) =>
      gestureModel.isTap = function;

  void onTap(final void Function() function) => gestureModel.onTap = function;

  void onTapUp(final void Function(TapUpDetails) function) =>
      gestureModel.onTapUp = function;

  void onTapDown(final void Function(TapDownDetails) function) =>
      gestureModel.onTapDown = function;

  void onTapCancel(final void Function() function) =>
      gestureModel.onTapCancel = function;

  void onDoubleTap(final void Function() function) =>
      gestureModel.onDoubleTap = function;

  void onLongPress(final void Function() function) =>
      gestureModel.onLongPress = function;

  void onLongPressStart(final void Function(LongPressStartDetails) function) =>
      gestureModel.onLongPressStart = function;

  void onLongPressEnd(final void Function(LongPressEndDetails) function) =>
      gestureModel.onLongPressEnd = function;

  void onLongPressMoveUpdate(
    final void Function(LongPressMoveUpdateDetails) function,
  ) =>
      gestureModel.onLongPressMoveUpdate = function;

  void onLongPressUp(final void Function() function) =>
      gestureModel.onLongPressUp = function;

  void onVerticalDragStart(final void Function(DragStartDetails) function) =>
      gestureModel.onVerticalDragStart = function;

  void onVerticalDragEnd(final void Function(DragEndDetails) function) =>
      gestureModel.onVerticalDragEnd = function;

  void onVerticalDragDown(final void Function(DragDownDetails) function) =>
      gestureModel.onVerticalDragDown = function;

  void onVerticalDragCancel(final void Function() function) =>
      gestureModel.onVerticalDragCancel = function;

  void onVerticalDragUpdate(final void Function(DragUpdateDetails) function) =>
      gestureModel.onVerticalDragUpdate = function;

  void onHorizontalDragStart(final void Function(DragStartDetails) function) =>
      gestureModel.onHorizontalDragStart = function;

  void onHorizontalDragEnd(final void Function(DragEndDetails) function) =>
      gestureModel.onHorizontalDragEnd = function;

  void onHorizontalDragDown(final void Function(DragDownDetails) function) =>
      gestureModel.onHorizontalDragDown = function;

  void onHorizontalDragCancel(final void Function() function) =>
      gestureModel.onHorizontalDragCancel = function;

  void onHorizontalDragUpdate(
    final void Function(DragUpdateDetails) function,
  ) =>
      gestureModel.onHorizontalDragUpdate = function;

  void onForcePressStart(final void Function(ForcePressDetails) function) =>
      gestureModel.onForcePressStart = function;

  void onForcePressEnd(final void Function(ForcePressDetails) function) =>
      gestureModel.onForcePressEnd = function;

  void onForcePressPeak(final void Function(ForcePressDetails) function) =>
      gestureModel.onForcePressPeak = function;

  void onForcePressUpdate(final void Function(ForcePressDetails) function) =>
      gestureModel.onForcePressUpdate = function;

  void onPanStart(final void Function(DragStartDetails) function) =>
      gestureModel.onPanStart = function;

  void onPanEnd(final void Function(DragEndDetails) function) =>
      gestureModel.onPanEnd = function;

  void onPanCancel(final void Function() function) =>
      gestureModel.onPanCancel = function;

  void onPanDown(final void Function(DragDownDetails) function) =>
      gestureModel.onPanDown = function;

  void onPanUpdate(final void Function(DragUpdateDetails) function) =>
      gestureModel.onPanUpdate = function;

  void onScaleStart(final void Function(ScaleStartDetails) function) =>
      gestureModel.onScaleStart = function;

  void onScaleEnd(final void Function(ScaleEndDetails) function) =>
      gestureModel.onScaleEnd = function;

  void onScaleUpdate(final void Function(ScaleUpdateDetails) function) =>
      gestureModel.onScaleUpdate = function;

  GestureModel get exportGesture => gestureModel;
}
