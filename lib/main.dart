import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo_livescore/configuration.dart';
import 'package:migratorydata_client_dart_v6/client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
// This widget is the root
// of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MatchesListWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MatchesListWidget extends StatefulWidget {
  @override
  _MatchesListWidgetState createState() => _MatchesListWidgetState();
}

class _MatchesListWidgetState extends State<MatchesListWidget>
    implements MigratoryDataListener {
  _MatchesListWidgetState() {
    connectClient(this);

    startSimulation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo'),
        backgroundColor: Colors.green,
      ),
      body: Column(children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Live Sports Scores",
            textScaleFactor: 2,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FixedColumnWidth(20.0),
              2: FixedColumnWidth(20.0),
              3: FixedColumnWidth(20.0),
              4: FlexColumnWidth(),
            },
            // border: TableBorder.all(width: 2.0, color: Colors.red),
            children: matches.entries
                .map((e) => TableRow(children: [
                      TableCellPadded(
                          color:
                              e.value['flash'] == 'home' ? Colors.yellow : null,
                          child: Text(
                            "${e.value['home_team']}",
                            textAlign: TextAlign.right,
                          )),
                      TableCellPadded(
                          color:
                              e.value['flash'] == 'home' ? Colors.yellow : null,
                          child:
                              Center(child: Text("${e.value['score_home']}"))),
                      const TableCellPadded(child: Center(child: Text('-'))),
                      TableCellPadded(
                          color:
                              e.value['flash'] == 'away' ? Colors.yellow : null,
                          child:
                              Center(child: Text("${e.value['score_away']}"))),
                      TableCellPadded(
                          color:
                              e.value['flash'] == 'away' ? Colors.yellow : null,
                          child: Text("${e.value['away_team']}")),
                    ]))
                .toList(),
          ),
        ),
      ]),
    );
  }

  @override
  onMessage(MigratoryDataMessage message) {
    var update = json.decode(utf8.decode(message.content));

    matches[update['id']]!['score_home'] = update['score_home'] % 10;
    matches[update['id']]!['score_away'] = update['score_away'] % 10;

    if (message.getMessageType() == MessageType.UPDATE) {
      if (update['goal'] == 'score_home') {
        matches[update['id']]!['flash'] = 'home';
      } else {
        matches[update['id']]!['flash'] = 'away';
      }
      Timer(Duration(seconds: 2), () {
        matches[update['id']]!['flash'] = '';
        setState(() {});
      });
      print('onMessage - $update');
    }

    setState(() {});
  }

  @override
  onStatus(String type, String info) {
    print('onStatus - $type - $info');
  }
}

class TableCellPadded extends StatelessWidget {
  final EdgeInsets? padding;
  final Widget child;
  final Color? color;

  const TableCellPadded(
      {Key? key, required this.child, this.padding, this.color})
      : super(key: key);

  @override
  TableCell build(BuildContext context) => TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
          padding: padding ?? const EdgeInsets.all(0.0),
          child: Container(
              color: color, alignment: Alignment.center, child: child)));
}
