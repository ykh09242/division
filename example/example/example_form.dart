import 'package:division/division.dart';
import 'package:flutter/material.dart';

void main() => runApp(const Main());

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(final BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Test(),
      ),
    );
  }
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  bool _isUsernameFieldActive = false;
  bool _isPasswordFieldActive = false;

  TxtStyle inputFieldStyle(final bool isActive, final TxtStyle activeStyle) =>
      TxtStyle()
        ..textColor(Colors.black)
        ..textAlign.left()
        ..fontSize(16)
        ..padding(horizontal: 15, vertical: 15)
        ..margin(horizontal: 50, vertical: 10)
        ..borderRadius(all: 10)
        ..alignment.center()
        ..background.color(Colors.grey[200]!)
        ..animate(300, Curves.easeOut)
        ..add(isActive ? activeStyle : null, override: true);

  final TxtStyle inputFieldActiveStyle = TxtStyle()
    ..background.color(Colors.blue)
    ..bold()
    ..textColor(Colors.white);

  final TxtStyle submitButtonStyle = TxtStyle()
    ..textColor(Colors.white)
    ..bold()
    ..ripple(true, splashColor: Colors.white.withOpacity(0.1))
    ..alignment.centerLeft()
    ..textAlign.center()
    ..width(150)
    ..background.color(Colors.blue)
    ..borderRadius(all: 10)
    ..margin(top: 30, horizontal: 50)
    ..padding(vertical: 15)
    ..elevation(10, opacity: 0.5);

  final TxtStyle titleStyle = TxtStyle()
    ..fontSize(24)
    ..bold()
    ..margin(bottom: 30, horizontal: 50)
    ..alignment.centerLeft();

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Txt('Login', style: titleStyle),
        Txt(
          '',
          style: inputFieldStyle(_isUsernameFieldActive, inputFieldActiveStyle)
            ..editable(
              autoFocus: true,
              placeholder: 'enter username',
              onFocusChange: (final bool? hasFocus) {
                if (hasFocus != _isUsernameFieldActive) {
                  setState(
                    () => _isUsernameFieldActive =
                        hasFocus ?? _isUsernameFieldActive,
                  );
                }
              },
            ),
        ),
        Txt(
          '',
          style: inputFieldStyle(_isPasswordFieldActive, inputFieldActiveStyle)
            ..editable(
              placeholder: 'enter password',
              obscureText: true,
              onFocusChange: (final bool? hasFocus) {
                if (hasFocus != _isPasswordFieldActive) {
                  setState(
                    () => _isPasswordFieldActive =
                        hasFocus ?? _isPasswordFieldActive,
                  );
                }
              },
            ),
        ),
        Txt('Submit', style: submitButtonStyle),
      ],
    );
  }
}
