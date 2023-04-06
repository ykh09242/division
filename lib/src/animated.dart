import 'package:division/src/build.dart';
import 'package:division/src/model.dart';
import 'package:flutter/material.dart';

class CoreAnimated extends ImplicitlyAnimatedWidget {
  CoreAnimated({
    super.key,
    this.styleModel,
    this.gestureModel,
    this.child,
  }) : super(curve: styleModel!.curve!, duration: styleModel.duration!);

  final Widget? child;

  final StyleModel? styleModel;

  final GestureModel? gestureModel;

  @override
  ImplicitlyAnimatedWidgetState<CoreAnimated> createState() =>
      _CoreAnimatedState();
}

class _CoreAnimatedState extends AnimatedWidgetBaseState<CoreAnimated> {
  AlignmentGeometryTween? _alignment;
  AlignmentGeometryTween? _alignmentContent;
  EdgeInsetsGeometryTween? _padding;
  DecorationTween? _decoration;
  BoxConstraintsTween? _constraints;
  EdgeInsetsGeometryTween? _margin;
  Matrix4Tween? _transform;
  Tween<double?>? _blur;
  Tween<double?>? _opacity;

  @override
  void forEachTween(final TweenVisitor<dynamic> visitor) {
    _alignment = visitor(
      _alignment,
      widget.styleModel?.alignment,
      (final dynamic value) =>
          AlignmentGeometryTween(begin: value as AlignmentGeometry?),
    ) as AlignmentGeometryTween?;
    _alignmentContent = visitor(
      _alignmentContent,
      widget.styleModel?.alignmentContent,
      (final dynamic value) =>
          AlignmentGeometryTween(begin: value as AlignmentGeometry?),
    ) as AlignmentGeometryTween?;
    _padding = visitor(
      _padding,
      widget.styleModel?.padding,
      (final dynamic value) =>
          EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry?),
    ) as EdgeInsetsGeometryTween?;
    _decoration = visitor(
      _decoration,
      widget.styleModel?.decoration,
      (final dynamic value) => DecorationTween(begin: value as Decoration?),
    ) as DecorationTween?;
    _constraints = visitor(
      _constraints,
      widget.styleModel?.constraints,
      (final dynamic value) =>
          BoxConstraintsTween(begin: value as BoxConstraints?),
    ) as BoxConstraintsTween?;
    _margin = visitor(
      _margin,
      widget.styleModel?.margin,
      (final dynamic value) =>
          EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry?),
    ) as EdgeInsetsGeometryTween?;
    _transform = visitor(
      _transform,
      widget.styleModel?.transform,
      (final dynamic value) => Matrix4Tween(begin: value as Matrix4?),
    ) as Matrix4Tween?;
    _blur = visitor(
      _blur,
      widget.styleModel?.backgroundBlur,
      (final dynamic value) => Tween<double>(begin: value as double?),
    ) as Tween<double?>?;
    _opacity = visitor(
      _opacity,
      widget.styleModel?.opacity,
      (final dynamic value) => Tween<double>(begin: value as double?),
    ) as Tween<double?>?;
  }

  @override
  Widget build(final BuildContext context) {
    final StyleModel? styleModel = widget.styleModel;

    if (styleModel != null) {
      styleModel
        ..alignment = _alignment?.evaluate(animation)
        ..alignmentContent = _alignmentContent?.evaluate(animation)
        ..padding = _padding?.evaluate(animation)
        ..setBoxConstraints = _constraints?.evaluate(animation)
        ..setBoxDecoration = _decoration?.evaluate(animation) as BoxDecoration?
        ..margin = _margin?.evaluate(animation)
        ..setTransform = _transform?.evaluate(animation)
        ..backgroundBlur = _blur?.evaluate(animation)
        ..opacity = _opacity?.evaluate(animation);
    }

    return CoreBuild(
      styleModel: styleModel,
      gestureModel: widget.gestureModel,
      child: widget.child,
    );
  }
}

class TxtAnimated extends ImplicitlyAnimatedWidget {
  const TxtAnimated({
    required super.curve,
    required super.duration,
    required this.text,
    super.key,
    this.textModel,
  });

  final String text;

  final TextModel? textModel;

  @override
  ImplicitlyAnimatedWidgetState<TxtAnimated> createState() =>
      _TxtAnimatedState();
}

class _TxtAnimatedState extends AnimatedWidgetBaseState<TxtAnimated> {
  Tween<double>? _fontSize;
  ColorTween? _textColor;
  Tween<int>? _maxLines;
  Tween<double>? _letterSpacing;
  Tween<double>? _wordSpacing;

  @override
  void forEachTween(final TweenVisitor<dynamic> visitor) {
    _fontSize = visitor(
      _fontSize,
      widget.textModel?.fontSize,
      (final dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _textColor = visitor(
      _textColor,
      widget.textModel?.textColor,
      (final dynamic value) => ColorTween(begin: value as Color),
    ) as ColorTween?;
    _maxLines = visitor(
      _maxLines,
      widget.textModel?.maxLines,
      (final dynamic value) => Tween<int>(begin: value as int),
    ) as Tween<int>?;
    _letterSpacing = visitor(
      _letterSpacing,
      widget.textModel?.letterSpacing,
      (final dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _wordSpacing = visitor(
      _wordSpacing,
      widget.textModel?.wordSpacing,
      (final dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
  }

  @override
  Widget build(final BuildContext context) {
    final TextModel? textModel = widget.textModel;

    if (textModel != null) {
      textModel
        ..fontSize = _fontSize?.evaluate(animation)
        ..textColor = _textColor?.evaluate(animation)
        ..maxLines = _maxLines?.evaluate(animation)
        ..letterSpacing = _letterSpacing?.evaluate(animation)
        ..wordSpacing = _wordSpacing?.evaluate(animation);
    }

    if (textModel?.editable ?? false) {
      return TxtBuildEditable(
        text: widget.text,
        textModel: textModel,
      );
    } else {
      return TxtBuild(
        text: widget.text,
        textModel: textModel,
      );
    }
  }
}
