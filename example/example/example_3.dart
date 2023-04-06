import 'package:division/division.dart';
import 'package:flutter/material.dart';

void main() => runApp(const Main());

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  Home({super.key});

  final TxtStyle titleStyle = TxtStyle()
    ..padding(vertical: 30.0, horizontal: 20.0)
    ..bold()
    ..fontSize(36);

  final ParentStyle tasksCard = ParentStyle()
    ..width(100)
    ..height(100)
    ..borderRadius(all: 15.0)
    ..margin(left: 10.0, right: 10.0, top: 5.0, bottom: 55.0);

  final ParentStyle categoriesCard = ParentStyle()
    ..width(200)
    ..height(200)
    ..borderRadius(all: 15.0)
    ..background.hex('#ffffff')
    ..elevation(25)
    ..alignment.topCenter()
    ..margin(left: 10.0, right: 10.0, top: 10.0, bottom: 55.0);

  final TxtStyle searchBarStyle = TxtStyle()
    ..width(300)
    ..padding(horizontal: 20.0, vertical: 15.0)
    ..margin(top: 0.0, bottom: 20.0)
    ..borderRadius(all: 10.0)
    ..alignment.center()
    ..elevation(15, color: Colors.grey)
    ..background.hex('#ffffff')
    ..textColor(Colors.black54)
    ..fontSize(18)
    ..bold()
    ..editable();

  final TxtStyle undertitleStyle = TxtStyle()
    ..margin(left: 20)
    ..textColor(Colors.black.withOpacity(0.8))
    ..bold()
    ..fontSize(22)
    ..textAlign.left();

  ParentStyle colorCardStyle(final ParentStyle tasksCard, final Color color) =>
      tasksCard.clone()
        ..background.color(color)
        ..elevation(20, color: color.withOpacity(0.5));

  Widget _buildTasksCardRow() {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Parent(style: colorCardStyle(tasksCard, const Color(0xFFFFB85D))),
          Parent(style: colorCardStyle(tasksCard, const Color(0xFFFD5C63))),
          Parent(style: colorCardStyle(tasksCard, const Color(0xFF828AFF))),
          Parent(style: colorCardStyle(tasksCard, const Color(0xFF55ffff))),
        ],
      ),
    );
  }

  Widget _buildCategoriesCardRow() {
    return SizedBox(
      height: 300,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Parent(style: categoriesCard),
          Parent(style: categoriesCard),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Txt('Home', style: titleStyle),
          Txt('Search..', style: searchBarStyle),
          Txt('Tasks', style: undertitleStyle),
          _buildTasksCardRow(),
          Txt('Categories', style: undertitleStyle),
          _buildCategoriesCardRow()
        ],
      ),
    );
  }
}
