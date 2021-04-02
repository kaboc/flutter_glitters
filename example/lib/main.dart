import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:glitters/glitters.dart';
import 'package:glitters/single_glitter.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Glitters'),
          backwardsCompatibility: false,
          backgroundColor: Colors.grey.shade700,
          systemOverlayStyle: SystemUiOverlayStyle.light,
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
                    backgroundColor: Color(0xFF455A64),
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
                    color: Color(0xFF455A64),
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
