import 'package:flutter/material.dart';
import '../../Classes/player.dart';

class Night extends StatefulWidget {
  @override
  _NightState createState() => _NightState();
}

class _NightState extends State<Night> {
  int numberOfVillagers = 1;

  Player testVampire = new Player(
    isAlive: true,
    isAdmin: false,
    email: 'Eren',
    role: 'vampire',
  );
  Player testVillager = new Player(
    isAlive: true,
    isAdmin: false,
    email: 'Cafer',
    role: 'villager',
  );

  Widget vampireNightScreen() {
    List<Player> aliveVillagers = [testVillager];
    return Scaffold(
        appBar: AppBar(
          title: Text('Night'),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: aliveVillagers.length,
          itemBuilder: (context, index) {
            return ChoiceChip(
              selected: !aliveVillagers[index].isAlive,
              label: Text(index.toString()),
              onSelected: (bool selected) {
                setState(
                  () {
                    aliveVillagers[index].isAlive =
                        !aliveVillagers[index].isAlive;
                  },
                );
              },
            );
          },
        ));
  }

  Widget villagerNightScreen() {
    List<Player> alivePlayers = [testVillager, testVampire];
    return Scaffold(
        appBar: AppBar(
          title: Text('Night'),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: alivePlayers.length,
          itemBuilder: (context, index) {
            return ChoiceChip(
              selected: !alivePlayers[index].isAlive,
              label: Text(index.toString()),
              onSelected: (bool selected) {
                setState(
                  () {
                    alivePlayers[index].isAlive = !alivePlayers[index].isAlive;
                  },
                );
              },
            );
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return (testVampire.role != 'vampire')
        ? vampireNightScreen()
        : villagerNightScreen();
  }
}
