import 'package:flutter/material.dart';

import 'package:glitters/glitters.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Glitters';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
          backgroundColor: Colors.grey.shade700,
        ),
        body: SafeArea(
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.6,
              heightFactor: 0.6,
              child: ColoredBox(
                color: Colors.blueGrey.shade700,
                child: Stack(
                  children: const <Widget>[
                    Glitters(
                      minSize: 8.0,
                      maxSize: 20.0,
                      interval: Duration.zero,
                      maxOpacity: 0.7,
                    ),
                    Glitters(
                      minSize: 10.0,
                      maxSize: 25.0,
                      interval: Duration(milliseconds: 20),
                      color: Colors.lime,
                    ),
                    Glitters(
                      minSize: 10.0,
                      maxSize: 25.0,
                      duration: Duration(milliseconds: 200),
                      inDuration: Duration(milliseconds: 500),
                      outDuration: Duration(milliseconds: 500),
                      interval: Duration(milliseconds: 30),
                      color: Colors.white,
                      maxOpacity: 0.7,
                    ),
                    Glitters(
                      minSize: 14.0,
                      maxSize: 30.0,
                      interval: Duration(milliseconds: 40),
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
