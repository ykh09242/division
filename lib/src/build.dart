import 'dart:ui';

import 'package:division/src/model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CoreBuild extends StatelessWidget {
  CoreBuild({super.key, this.child, this.styleModel, this.gestureModel})
      : decoration = styleModel?.decoration,
        constraints = styleModel?.constraints;

  final Widget? child;
  final StyleModel? styleModel;
  final GestureModel? gestureModel;

  final BoxDecoration? decoration;
  final BoxConstraints? constraints;

  EdgeInsetsGeometry? get _paddingIncludingDecoration {
    if (decoration == null) {
      return styleModel?.padding;
    }
    final EdgeInsetsGeometry decorationPadding = decoration!.padding;
    if (styleModel?.padding == null) {
      return decorationPadding;
    }
    final EdgeInsetsGeometry padding = styleModel!.padding!;
    return padding.add(decorationPadding);
  }

  @override
  Widget build(final BuildContext context) {
    Widget? widgetTree = child;

    if (child == null && (constraints == null || !constraints!.isTight)) {
      widgetTree = LimitedBox(
        maxWidth: 0.0,
        maxHeight: 0.0,
        child: ConstrainedBox(constraints: const BoxConstraints.expand()),
      );
    }

    if (styleModel?.alignmentContent != null) {
      widgetTree =
          Align(alignment: styleModel!.alignmentContent!, child: widgetTree);
    }

    final EdgeInsetsGeometry? effectivePadding = _paddingIncludingDecoration;
    if (effectivePadding != null) {
      widgetTree = Padding(padding: effectivePadding, child: widgetTree);
    }

    // ignore: missing_enum_constant_in_switch
    switch (styleModel?.overflow) {
      case OverflowType.scroll:
        widgetTree = SingleChildScrollView(
          scrollDirection: styleModel!.overflowDirection!,
          child: widgetTree,
        );
        break;
      case OverflowType.hidden:
        widgetTree = ClipRRect(
          borderRadius: decoration?.borderRadius as BorderRadius? ??
              BorderRadius.circular(0.0),
          child: widgetTree,
        );
        break;
      case OverflowType.visible:
        widgetTree = OverflowBox(
          maxHeight: styleModel?.overflowDirection == Axis.vertical
              ? double.infinity
              : null,
          maxWidth: styleModel?.overflowDirection == Axis.horizontal
              ? double.infinity
              : null,
          alignment: styleModel?.alignmentContent ?? Alignment.topCenter,
          child: widgetTree,
        );
        break;
    }

    if (styleModel?.ripple?.enable ?? false) {
      widgetTree = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: gestureModel?.onTap ?? () {},
          borderRadius: decoration?.borderRadius as BorderRadius?,
          highlightColor: styleModel?.ripple?.highlightColor,
          splashColor: styleModel?.ripple?.splashColor,
          child: widgetTree,
        ),
      );
    }

    if (decoration != null) {
      widgetTree = DecoratedBox(decoration: decoration!, child: widgetTree);
    }

    if (gestureModel != null) {
      widgetTree = gestures(widgetTree!, gestureModel);
    }

    if (constraints != null) {
      widgetTree = ConstrainedBox(constraints: constraints!, child: widgetTree);
    }

    if (styleModel?.margin != null) {
      widgetTree = Padding(padding: styleModel!.margin!, child: widgetTree);
    }

    if (styleModel?.backgroundBlur != null) {
      widgetTree = ClipRRect(
        borderRadius: decoration?.borderRadius as BorderRadius?,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: styleModel!.backgroundBlur!,
            sigmaY: styleModel!.backgroundBlur!,
          ),
          child: widgetTree,
        ),
      );
    }

    if (styleModel?.alignment != null) {
      widgetTree = Align(alignment: styleModel!.alignment!, child: widgetTree);
    }

    if (styleModel?.transform != null) {
      widgetTree = Transform(
        alignment: FractionalOffset.center,
        transform: styleModel!.transform!,
        child: widgetTree,
      );
    }

    if (styleModel?.opacity != null) {
      widgetTree = Opacity(opacity: styleModel!.opacity!, child: widgetTree);
    }

    return widgetTree!;
  }

  Widget gestures(final Widget widgetTree, final GestureModel? gesture) {
    return GestureDetector(
      onTapDown: (final TapDownDetails tapDownDetails) {
        if (gesture?.onTapDown != null) {
          gesture!.onTapDown!(tapDownDetails);
        }
        if (gesture?.isTap != null) {
          gesture!.isTap!(true);
        }
      },
      onTapUp: (final TapUpDetails tapUpDetails) {
        if (gesture?.onTapUp != null) {
          gesture!.onTapUp!(tapUpDetails);
        }
        if (gesture?.isTap != null) {
          gesture!.isTap!(false);
        }
      },
      onTapCancel: () {
        if (gesture?.onTapCancel != null) {
          gesture!.onTapCancel!();
        }
        if (gesture?.isTap != null) {
          gesture!.isTap!(false);
        }
      },
      onTap: gesture?.onTap,
      onDoubleTap: gesture?.onDoubleTap,
      onLongPress: gesture?.onLongPress,
      onLongPressStart: gesture?.onLongPressStart,
      onLongPressEnd: gesture?.onLongPressEnd,
      onLongPressMoveUpdate: gesture?.onLongPressMoveUpdate,
      onLongPressUp: gesture?.onLongPressUp,
      onVerticalDragStart: gesture?.onVerticalDragStart,
      onVerticalDragEnd: gesture?.onVerticalDragEnd,
      onVerticalDragDown: gesture?.onVerticalDragDown,
      onVerticalDragCancel: gesture?.onVerticalDragCancel,
      onVerticalDragUpdate: gesture?.onVerticalDragUpdate,
      onHorizontalDragStart: gesture?.onHorizontalDragStart,
      onHorizontalDragEnd: gesture?.onHorizontalDragEnd,
      onHorizontalDragCancel: gesture?.onHorizontalDragCancel,
      onHorizontalDragUpdate: gesture?.onHorizontalDragUpdate,
      onHorizontalDragDown: gesture?.onHorizontalDragDown,
      onForcePressStart: gesture?.onForcePressStart,
      onForcePressEnd: gesture?.onForcePressEnd,
      onForcePressPeak: gesture?.onForcePressPeak,
      onForcePressUpdate: gesture?.onForcePressUpdate,
      onPanStart: gesture?.onPanStart,
      onPanEnd: gesture?.onPanEnd,
      onPanCancel: gesture?.onPanCancel,
      onPanDown: gesture?.onPanDown,
      onPanUpdate: gesture?.onPanUpdate,
      onScaleStart: gesture?.onScaleStart,
      onScaleEnd: gesture?.onScaleEnd,
      onScaleUpdate: gesture?.onScaleUpdate,
      behavior: gesture?.behavior,
      excludeFromSemantics: gesture?.excludeFromSemantics ?? false,
      dragStartBehavior: gesture?.dragStartBehavior ?? DragStartBehavior.start,
      child: widgetTree,
    );
  }
}

class ParentBuild extends StatelessWidget {
  const ParentBuild({required this.child, super.key});

  final Widget child;

  @override
  Widget build(final BuildContext context) => child;
}

class TxtBuild extends StatelessWidget {
  const TxtBuild({super.key, this.text, this.textModel});

  final String? text;
  final TextModel? textModel;

  @override
  Widget build(final BuildContext context) => Text(
        text!,
        style: textModel?.textStyle,
        textAlign: textModel?.textAlign ?? TextAlign.start,
        maxLines: textModel?.maxLines,
        textDirection: textModel?.textDirection,
        overflow: textModel?.textOverflow,
      );
}

class TxtBuildEditable extends StatefulWidget {
  TxtBuildEditable({required this.text, super.key, this.textModel})
      : textStyle = textModel?.textStyle,
        placeholderController =
            TextEditingController(text: textModel?.placeholder);

  final String text;
  final TextModel? textModel;
  final TextStyle? textStyle;
  final TextEditingController placeholderController;

  @override
  State<TxtBuildEditable> createState() => _TxtBuildEditableState();
}

class _TxtBuildEditableState extends State<TxtBuildEditable> {
  String? _initialTextValue;
  late TextEditingController _controller;
  FocusNode? _focusNode;
  TextStyle? _placeholderTextStyle;
  bool _showPlaceholder = true;
  bool? _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _initialTextValue = widget.text;
    _controller = TextEditingController(text: widget.text);
    _updatePlaceholderTextStyle();
    _initializeFocusNode();
  }

  @override
  void didUpdateWidget(final TxtBuildEditable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.textStyle != oldWidget.textStyle) {
      _updatePlaceholderTextStyle();
    }

    if (widget.text != _initialTextValue) {
      _initialTextValue = widget.text;
      _controller = TextEditingController(text: widget.text);
    }
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _updatePlaceholderTextStyle() {
    _placeholderTextStyle = widget.textStyle?.copyWith(
      color: widget.textStyle?.color?.withOpacity(0.7) ?? Colors.grey,
      fontWeight: FontWeight.normal,
    );
  }

  void _initializeFocusNode() {
    _focusNode ??= widget.textModel?.focusNode ?? FocusNode();

    _focusNode?.addListener(() {
      // only when focus changes
      final bool? hasFocus = _focusNode?.hasFocus;
      if (hasFocus != _hasFocus) {
        _hasFocus = hasFocus;
        _shouldShowPlaceholder();
        if (widget.textModel?.onFocusChange != null) {
          widget.textModel!.onFocusChange!(_hasFocus);
        }
      }
    });
  }

  void _shouldShowPlaceholder() {
    if (_controller.text.isEmpty &&
        _hasFocus == false &&
        _showPlaceholder == false) {
      setState(() => _showPlaceholder = true);
    } else if (_showPlaceholder == true) {
      setState(() => _showPlaceholder = false);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return EditableText(
      obscureText:
          !_showPlaceholder && (widget.textModel?.obscureText ?? false),
      autofocus: widget.textModel?.autoFocus ?? false,
      cursorOpacityAnimates: true,
      style: (_showPlaceholder ? _placeholderTextStyle : widget.textStyle) ??
          const TextStyle(),
      textAlign: widget.textModel?.textAlign ?? TextAlign.start,
      maxLines: widget.textModel?.maxLines ?? 1,
      textDirection: widget.textModel?.textDirection,
      controller: _showPlaceholder ? widget.placeholderController : _controller,
      focusNode: _focusNode!,
      backgroundCursorColor: Colors.grey,
      cursorColor: Colors.black,
      keyboardType: widget.textModel?.keyboardType ?? TextInputType.text,
      onChanged: widget.textModel?.onChange,
      onSelectionChanged: widget.textModel?.onSelectionChanged,
      onEditingComplete: () {
        _focusNode?.unfocus();
        _controller.clearComposing();
        if (widget.textModel?.onEditingComplete != null) {
          widget.textModel!.onEditingComplete!();
        }
      },
    );
  }
}
