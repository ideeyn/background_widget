/// mending ganti ke sini: [https://pub.dev/packages/flutter_local_notifications/example]

import 'package:flutter/material.dart';

void main() {
  runApp(const Aplikasi());
}

class Aplikasi extends StatelessWidget {
  const Aplikasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tes Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors
              .blue), // bisa juga ThemeData(appBarTheme: AppBarTheme(backgroundColor: Colors.blue))
      home: const Text('halo'),
    );
  }
}

// import 'dart:async';
// import 'dart:ui';
// import 'dart:isolate';
// import 'dart:developer' as developer;
// import 'package:flutter/material.dart';

// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// // see note in android/settings.gradle when adding this package. missing documentation
// import 'package:permission_handler/permission_handler.dart';
// import 'package:home_widget/home_widget.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:background_fetch/background_fetch.dart';

// /// The name associated with the UI isolate's [SendPort].
// const String isolateName = 'isolate';

// /// A port used to communicate from a background isolate to the UI isolate.
// ReceivePort port = ReceivePort();

// /// Global [SharedPreferences] object.
// SharedPreferences? prefs;

// /// The [SharedPreferences] key to access the alarm fire last time.
// const String lastTime = 'last';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // REQUIRED to do backgrounds

//   // Register the UI isolate's SendPort to allow for communication from the
//   // background isolate.
//   IsolateNameServer.registerPortWithName(
//     port.sendPort,
//     isolateName,
//   );
//   prefs = await SharedPreferences.getInstance();
//   if (!prefs!.containsKey(lastTime)) {
//     await prefs!.setString(lastTime, "unconfigured");
//   }
//   runApp(const Aplikasi());
// }

// class Aplikasi extends StatefulWidget {
//   const Aplikasi({super.key});

//   @override
//   State<Aplikasi> createState() => _AplikasiState();
// }

// class _AplikasiState extends State<Aplikasi> {
//   late Timer _timer;
//   DateTime _currentTime = DateTime.now();
//   PermissionStatus _exactAlarmPermissionStatus = PermissionStatus.granted;

//   @override
//   void initState() {
//     super.initState();
//     AndroidAlarmManager.initialize();
//     _checkExactAlarmPermission();
//     // for in-app ui, updating widget every second
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       _currentTime = DateTime.now();
//       setState(() {});
//     });
//     // Register for events from the background isolate. These messages will
//     // always coincide with an alarm firing.
//     port.listen((_) async => await _incrementCounter());
//   }

//   void _checkExactAlarmPermission() async {
//     final currentStatus = await Permission.scheduleExactAlarm.status;
//     setState(() {
//       _exactAlarmPermissionStatus = currentStatus;
//     });
//   }

//   Future<void> _incrementCounter() async {
//     developer.log('Increment counter!');
//     // Ensure we've loaded the updated count from the background isolate.
//     await prefs?.reload();

//     GoUpdate.widget();
//   }

//   // The background
//   static SendPort? uiSendPort;

//   // The callback for our alarm
//   @pragma('vm:entry-point')
//   static Future<void> callback() async {
//     developer.log('Alarm fired!');
//     // Get the previous cached count and increment it.
//     final prefz = await SharedPreferences.getInstance();
//     await prefz.setString(
//         lastTime, '${DateTime.now().minute}:${DateTime.now().second}');
//     GoUpdate.widget();

//     // This will be null if we're running in the background.
//     uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
//     uiSendPort?.send(null);
//   }

//   @override
//   void dispose() {
//     _timer.cancel(); // Cancel the timer on dispose, avoiding callback error
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TheWidget(currentTime: _currentTime),
//               //
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _exactAlarmPermissionStatus.isGranted
//                     ? () async {
//                         await AndroidAlarmManager.cancel(111);
//                         await AndroidAlarmManager.periodic(
//                           const Duration(seconds: 15),
//                           // Ensure we have a unique alarm ID.
//                           111,
//                           callback,
//                           exact: true,
//                           wakeup: true,
//                         );
//                         GoUpdate.widget();
//                       }
//                     : null,
//                 child: const Text('Update Widget'),
//               ),
//               Text(
//                 'Last Update (min-sec): ${prefs?.getString(lastTime) ?? ''}',
//               ),
//               const SizedBox(height: 32),
//               ElevatedButton(
//                 onPressed: _exactAlarmPermissionStatus.isDenied
//                     ? () async {
//                         await Permission.scheduleExactAlarm
//                             .onGrantedCallback(() => setState(() {
//                                   _exactAlarmPermissionStatus =
//                                       PermissionStatus.granted;
//                                 }))
//                             .request();
//                       }
//                     : null,
//                 child: const Text('Request exact alarm permission'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // =========================================================================

// class GoUpdate {
//   static widget() {
//     WidgetConfig.update(TheWidget(currentTime: DateTime.now()));
//   }
// }

// // =========================================================================

// class TheWidget extends StatelessWidget {
//   const TheWidget({super.key, required this.currentTime});

//   final DateTime currentTime;

//   @override
//   Widget build(BuildContext context) {
//     List<Color> bgRand = [Colors.red, Colors.black, Colors.blue, Colors.green];
//     List<String> days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
//     TextStyle customStyle = const TextStyle(
//         color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25);

//     return Container(
//       color: bgRand[currentTime.minute ~/ 15.round()],
//       width: 170,
//       height: 170,
//       alignment: Alignment.center,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             '${currentTime.hour}:${currentTime.minute}:${currentTime.second}',
//             style: customStyle,
//           ),
//           const SizedBox(height: 10),
//           Text(
//             '${days[currentTime.weekday]}, ${currentTime.day}/${currentTime.month}',
//             style: customStyle,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // =========================================================================

// /// all here are [STATICS] from native folders. you can create a separated file for this.s
// String groupId = 'group.widget_simplest_group';
// String iosWidget = 'simplest_widget_mine';
// String androidWidget = 'SimplestWidgetMine';

// // =========================================================================

// class WidgetConfig {
//   static Future<void> update(Widget widget) async {
//     // Render the widget and capture the image data
//     String imageData = await HomeWidget.renderFlutterWidget(
//       widget, // hover on .renderFlutterWidget to see documentation
//       key: 'filename',
//       pixelRatio: 4.0, // Adjust pixel ratio for desired image quality
//       logicalSize: const Size(160, 320), // Set desired size for the widget
//     );

//     // Update the home screen widget using home_widget
//     await HomeWidget.saveWidgetData('filename', imageData);
//     await HomeWidget.updateWidget(
//         iOSName: iosWidget, androidName: androidWidget);
//   }

//   static Future<void> initialize() async {
//     await HomeWidget.setAppGroupId(groupId);
//   }
// }
