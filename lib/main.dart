import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:good_movie_fan/app.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager.initialize(dataSyncTask, isInDebugMode: true);
  Workmanager.registerPeriodicTask("1", "dataSyncTask",
      frequency: Duration(hours: 24),
      constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: true,
          requiresCharging: true,
          requiresDeviceIdle: true,
          requiresStorageNotLow: true));

  //TODO implement landscape design
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(GoodMovieFanApp()));
}

void dataSyncTask() {
  Workmanager.executeTask((task, inputData) {
    //TODO
    //refresh DB data for all favorites and dependencies
    //post dirty data (rated movie in offline... etc)
    return Future.value(true);
  });
}
