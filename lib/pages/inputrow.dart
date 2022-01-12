import 'package:flutter/material.dart';
class InputRowTest extends StatefulWidget {
  @override
  _InputRowTestState createState() => _InputRowTestState();
}

class _InputRowTestState extends State<InputRowTest> {
  List<String> list1 = ['Apples', 'Bananas', 'Peaches'];

  List<String> list1_1 = ['GreenApples', 'RedApples', 'YellowApples'];

  List<String> list1_2 = [
    'YellowBananas',
    'BrownBananas',
    'GreenBananas',
    'GreenApples'
  ];

  List<String> list1_3 = [
    'RedPeaches',
    'YellowPeaches',
    'GreenPeaches',
    'GreenApples'
  ];

  List<String>? _fromparent;
  int? _fromparentint;
  Widget? ddbff;
  var selected;
  bool? chance;

  Widget ddff(List<String> list, bool chance) {
    return (chance)
        ? DropdownButtonFormField(
      value: list[0], //Seems this value wont change.
      items: list.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Container(
            child: Text(category),
          ),
        );
      }).toList(),
      onChanged: (val) {
        print(val);
      },
    )
        : Container(
      child: DropdownButtonFormField(
        value: list[0], //Seems this value wont change.
        items: list.map((category) {
          return DropdownMenuItem(
            value: category,
            child: Container(
              child: Text(category),
            ),
          );
        }).toList(),
        onChanged: (val) {
          print(val);
        },
      ),
    );
  }

  @override
  void initState() {
    _fromparent = list1_1;
    _fromparentint = 0;
    selected = list1_1[0];
    chance = true;
    ddbff = ddff(_fromparent!, chance!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<List<String>> subLists = [list1_1, list1_2, list1_3];
    _fromparent = subLists[_fromparentint!];

    chance = !chance!;
    ddbff = ddff(_fromparent!, chance!);

    return Center(
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: DropdownButtonFormField(
                value: list1[0],
                items: list1.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Container(
                      child: Text(category),
                    ),
                  );
                }).toList(),
                onChanged: (String? val) {
                  setState(() {
                    _fromparentint = list1.indexOf(val!);
                  });
                },
              ),
            ),
            Expanded(
              child: ddbff!,
            ),
          ],
        ),
      ),
    );
  }
}