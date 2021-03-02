import 'package:flutter/material.dart';

import 'package:glitters/glitters.dart';
import 'package:glitters/single_glitter.dart';

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
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Glitters'),
                const SizedBox(height: 4.0),
                Expanded(
                  flex: 2,
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
                const SizedBox(height: 36.0),
                const Text('SingleGlitter'),
                const SizedBox(height: 4.0),
                Expanded(
                  child: ColoredBox(
                    color: Colors.blueGrey.shade700,
                    child: const SingleGlitter(
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
