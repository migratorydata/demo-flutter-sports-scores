import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:migratorydata_client_dart_v6/client.dart';

const server = 'demo.migratorydata.com';
const encryption = true;
const token = 'some-token';
const subjectPrefix = '/matches/football/';

final rng = Random();

var matches = {
  'id1': {
    'id': 'id1',
    'home_team': 'Fenerbahce (Tur)',
    'away_team': 'Partizan (Srb)',
    'score_home': 0,
    'score_away': 0,
    'flash' : '',
  },
  'id2': {
    'id': 'id2',
    'home_team': 'Olympiakos (Gre)',
    'away_team': 'Slovan Bratislava (Svk)',
    'score_home': 0,
    'score_away': 0,
    'flash' : '',
  },
  'id3': {
    'id': 'id3',
    'home_team': 'Benfica (Por)',
    'away_team': 'Midtjylland (Den)',
    'score_home': 0,
    'score_away': 0,
    'flash' : '',
  },
  'id4': {
    'id': 'id4',
    'home_team': 'PSV (Ned)',
    'away_team': 'Monaco (Fra)',
    'score_home': 0,
    'score_away': 0,
    'flash' : '',
  },
  'id5': {
    'id': 'id5',
    'home_team': 'Guimaraes (Por)',
    'away_team': 'Hajduk Split (Cro)',
    'score_home': 0,
    'score_away': 0,
    'flash' : '',
  },
  'id6': {
    'id': 'id6',
    'home_team': 'Malmo FF (Swe)',
    'away_team': 'Dudelange (Lux)',
    'score_home': 0,
    'score_away': 0,
    'flash' : '',
  },
  'id7': {
    'id': 'id7',
    'home_team': 'Maribor (Slo)',
    'away_team': 'HJK (Fin)',
    'score_home': 0,
    'score_away': 0,
    'flash' : '',
  },
  'id8': {
    'id': 'id8',
    'home_team': 'Paide (Est)',
    'away_team': 'Anderlecht (Bel)',
    'score_home': 0,
    'score_away': 0,
    'flash' : '',
  },
  'id9': {
    'id': 'id9',
    'home_team': 'Neftci Baku (Aze)',
    'away_team': 'Rapid Viena (Aut)',
    'score_home': 0,
    'score_away': 0,
    'flash' : '',
  },
  'id10': {
    'id': 'id10',
    'home_team': 'Soligorsk (Blr)',
    'away_team': 'CFR Cluj (Rou)',
    'score_home': 0,
    'score_away': 0,
    'flash' : '',
  },
};

var matchesKeys = matches.keys.toList();
var matchesList = matches.entries.map((e) => "${e.value['home_team']} ${e.value['score_home']} - ${e.value['score_away']} ${e.value['away_team']}").toList();
var subjects = matchesKeys.map((e) => subjectPrefix + e).toList();

final migratoryDataClient = MigratoryDataClient();

void startSimulation() {
  print('Simulation started!');
  Timer.periodic(Duration(seconds: 2), (Timer t) {
    scoreSimulation();
  });
}

void scoreSimulation() {
  for (var i = 0; i < rng.nextInt(5); i += 1) {
    var match = matches[matchesKeys[rng.nextInt(matches.length)]];
    var scoreUpdate = rng.nextInt(2) == 0 ? 'score_home' : 'score_away';
    match![scoreUpdate] = (match[scoreUpdate] as int) + 1;
    var content = json.encode({
      'id': match['id'],
      'score_home': match['score_home'],
      'score_away': match['score_away'],
      'goal': scoreUpdate
    });
    migratoryDataClient.publish(MigratoryDataMessage(
        subjectPrefix + (match['id'] as String),
        Uint8List.fromList(utf8.encode(content))));
  }
}

void connectClient(MigratoryDataListener listener) {
  migratoryDataClient.setEntitlementToken(token);
  migratoryDataClient.setListener(listener);
  migratoryDataClient.setEncryption(encryption);
  migratoryDataClient.setServers([server]);
  migratoryDataClient.subscribe(subjects);
  migratoryDataClient.connect();
}

