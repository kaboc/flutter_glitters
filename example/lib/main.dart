import 'package:flutter/material.dart';

import 'package:glitters/glitters.dart';
import 'package:glitters/single_glitter.dart';

const _kBackgroundColor = Color(0xFF424242);

void main() => runApp(const App());

class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: const ColorScheme.dark(primary: _kBackgroundColor),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Glitters'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Glitters'),
                SizedBox(height: 4.0),
                Expanded(
                  flex: 2,
                  child: GlitterStack(
                    backgroundColor: _kBackgroundColor,
                    minSize: 15.0,
                    maxSize: 30.0,
                    interval: Duration(milliseconds: 300),
                    duration: Duration(milliseconds: 300),
                    inDuration: Duration(milliseconds: 300),
                    outDuration: Duration(milliseconds: 300),
                    maxOpacity: 0.7,
                    children: [
                      Glitters(),
                      Glitters(
                        color: Colors.lime,
                        delay: Duration(milliseconds: 300),
                      ),
                      Glitters(
                        color: Colors.white,
                        delay: Duration(milliseconds: 600),
                      ),
                      Glitters(
                        color: Colors.orange,
                        delay: Duration(milliseconds: 900),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 36.0),
                Text('SingleGlitter'),
                SizedBox(height: 4.0),
                Expanded(
                  child: ColoredBox(
                    color: _kBackgroundColor,
                    child: SingleGlitter(
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
