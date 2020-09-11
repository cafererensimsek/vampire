import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vampir/logic/home_logic.dart';
import 'package:vampir/shared/player.dart';

class BottomSheetButton extends StatefulWidget {
  final BuildContext context;
  final Player player;
  final int vampireCount;

  const BottomSheetButton(
      {Key key,
      @required this.context,
      @required this.player,
      @required this.vampireCount})
      : super(key: key);
  @override
  _BottomSheetButtonState createState() =>
      _BottomSheetButtonState(context, player, vampireCount);
}

class _BottomSheetButtonState extends State<BottomSheetButton> {
  final BuildContext context;
  final Player player;
  int vampireCount;

  _BottomSheetButtonState(this.context, this.player, this.vampireCount);

  @override
  Widget build(BuildContext context) {
    String newSessionID = Random().nextInt(1000000).toString();
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => showModalBottomSheet(
        elevation: 10,
        context: context,
        builder: (ctx) {
          return Container(
            height: 225,
            child: Column(
              children: [
                SizedBox(height: 25),
                Text(
                  'Select the Number of Vampires',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                StatefulBuilder(
                  builder: (ctx, setState) {
                    return Center(
                      child: DropdownButton<int>(
                        hint: Text(
                          'Number of Vampires',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                        value: vampireCount,
                        icon: Icon(Icons.arrow_downward, color: Colors.black),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        underline: Container(
                          height: 2,
                          color: Colors.black,
                        ),
                        onChanged: (int newValue) =>
                            setState(() => vampireCount = newValue),
                        items: <int>[1, 2, 3, 4, 5]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 50),
                RaisedButton(
                  color: Colors.black,
                  textColor: Colors.white,
                  child: Text('Create'),
                  onPressed: () async {
                    await createGame(
                      player,
                      newSessionID,
                      vampireCount,
                      context,
                      player,
                      vampireCount,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
