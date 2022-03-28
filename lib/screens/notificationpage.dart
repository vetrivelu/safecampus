// import 'package:flutter/material.dart';

// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';

// import '../main.dart';

// class NotificationPage extends StatefulWidget {
//   const NotificationPage({Key? key}) : super(key: key);

//   @override
//   _NotificationPageState createState() => _NotificationPageState();
// }

// class _NotificationPageState extends State<NotificationPage> {
//   var notification = [];
//   late Set<String> keys;

//   @override
//   void initState() {
//     super.initState();
//     // print(keys);
//   }

//   Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
//     if (state == AppLifecycleState.resumed) {
//       // Shared preferences
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.reload();
//       keys.addAll(prefs.getKeys());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notification'),
//         automaticallyImplyLeading: true,
//         // centerTitle: true,
//       ),
//       body: FutureBuilder(
//           future: prefs,
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (snapshot.hasData) {
//               SharedPreferences prefs = snapshot.data;
//               prefs.reload();
//               keys = prefs.getKeys();
//               for (var key in keys) {
//                 if (key == 'Value') {
//                   continue;
//                 }
//                 var result = prefs.getStringList(key);

//                 // print(date.toString());
//                 if (result != null) {
//                   result.add(key);
//                   notification.add(result);
//                 }
//               }
//               return ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: keys.length,
//                   itemBuilder: (context, index) {
//                     DateTime date = DateTime.parse(notification[index][2]);
//                     // print(notification[index][2]);
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           ListTile(
//                             isThreeLine: true,
//                             trailing: IconButton(
//                               icon: const Icon(Icons.delete),
//                               onPressed: () {
//                                 prefs.remove("${notification[index][2]}");
//                                 setState(() {
//                                   notification.remove('${notification[index]}');
//                                 });
//                               },
//                             ),
//                             subtitle: Padding(
//                               padding: const EdgeInsets.only(top: 8),
//                               child: Text(notification[index][0]),
//                             ),
//                             leading: const Icon(
//                               Icons.circle_notifications,
//                               size: 50,
//                             ),
//                             title: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   notification[index][1],
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       "${date.day}/${date.month}/${date.year}",
//                                       style: const TextStyle(fontSize: 12),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 8),
//                                       child: Text(
//                                         DateFormat.jm().format(
//                                           DateTime.parse(notification[index][2]),
//                                         ),
//                                         style: const TextStyle(fontSize: 12),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const Divider(),
//                         ],
//                       ),
//                     );
//                   });
//             } else if (snapshot.hasError) {
//               return const Icon(Icons.error_outline);
//             } else {
//               return const CircularProgressIndicator();
//             }
//           }),
//     );
//     // return Container();
//   }
// }
