import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late StreamSubscription subscription;
  late StreamSubscription internetSubscription;

  bool hasInternet = false;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((event) {
      _showConnectivitySnackbar(event);
    });

    internetSubscription = InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status ==InternetConnectionStatus.connected;

      setState(() {
        this.hasInternet = hasInternet;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

           buildInternetStatus(),

          ElevatedButton(
              onPressed: () async {
                final result = await Connectivity().checkConnectivity();
                _showConnectivitySnackbar(result);
              },
              child: const Text("Check connectivity"))
        ],
      )),
    );
  }

  void _showConnectivitySnackbar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final message = hasInternet
        ? result == ConnectivityResult.mobile
            ? "you are connected to MOBILE network"
            : "you are connected to WIFI network"
        : "you have no network";
    final color = hasInternet? Colors.green : Colors.red ;

    _showSnackbar(context , message , color);
  }

  void _showSnackbar(BuildContext context, String message, MaterialColor color) {
    final snackbar = SnackBar(content: Text(message!) , backgroundColor: color,);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Column buildInternetStatus() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Text("Connection Status"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              hasInternet ? Icons.done : Icons.error,
              color: hasInternet? Colors.green :Colors.red,
              size: 40,
            ),
             const SizedBox(height: 10,),
            
            Text(hasInternet? "Internet available" : "No internet")

          ],
        )
      ],
    );
  }
}
