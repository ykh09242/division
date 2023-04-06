import 'package:division/src/animated.dart';
import 'package:division/src/build.dart';
import 'package:division/src/model.dart';
import 'package:division/src/style.dart';
import 'package:flutter/material.dart';

class Parent extends StatelessWidget {
  const Parent({required this.style, super.key, this.child, this.gesture});

  final Widget? child;
  final ParentStyle style;
  final Gestures? gesture;

  @override
  Widget build(final BuildContext context) {
    final StyleModel styleModel = style.exportStyle;
    final GestureModel? gestureModel = gesture?.exportGesture;

    Widget? widgetTree;

    if (child != null) {
      widgetTree = ParentBuild(child: child!);
    }

    if (styleModel.duration != null) {
      //animated
      widgetTree = CoreAnimated(
        styleModel: styleModel,
        gestureModel: gestureModel,
        child: widgetTree,
      );
    } else {
      // static
      widgetTree = CoreBuild(
        styleModel: styleModel,
        gestureModel: gestureModel,
        child: widgetTree,
      );
    }

    return widgetTree;
  }
}

class Txt extends StatelessWidget {
  const Txt(this.text, {super.key, this.style, this.gesture});

  final String text;
  final TxtStyle? style;
  final Gestures? gesture;

  @override
  Widget build(final BuildContext context) {
    Widget widgetTree;
    final StyleModel? styleModel = style?.exportStyle;
    final TextModel? textModel = style?.exportTextStyle;
    final GestureModel? gestureModel = gesture?.exportGesture;

    if (styleModel?.curve != null && styleModel?.duration != null) {
      widgetTree = TxtAnimated(
        text: text,
        textModel: textModel,
        curve: styleModel!.curve!,
        duration: styleModel.duration!,
      );
    } else if (textModel?.editable ?? false) {
      widgetTree = TxtBuildEditable(
        text: text,
        textModel: textModel,
      );
    } else {
      widgetTree = TxtBuild(
        text: text,
        textModel: textModel,
      );
    }

    if (styleModel?.duration != null) {
      return CoreAnimated(
        gestureModel: gestureModel,
        styleModel: styleModel,
        child: widgetTree,
      );
    } else {
      return CoreBuild(
        gestureModel: gestureModel,
        styleModel: styleModel,
        child: widgetTree,
      );
    }
  }
}
