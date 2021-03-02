# Glitters

[![Pub Version](https://img.shields.io/pub/v/glitters)](https://pub.dev/packages/glitters)

A glittering widget for Flutter.

![Screencast](https://user-images.githubusercontent.com/20254485/83968159-29878f00-a902-11ea-8c95-320154181eb6.gif)

## What it does

This package provides two types of widgets:

* [Glitters](https://pub.dev/documentation/glitters/latest/glitters/Glitters-class.html)
    * The main widget of this package that fades in and out glitter-like shapes one by one inside itself. This will be useful when you want some part of your app to look shiny.
* [SingleGlitter](https://pub.dev/documentation/glitters/latest/single_glitter/SingleGlitter-class.html)
    * Just an extra widget to draw a single static glitter-like shape.

## Code examples

**Simplest**

```dart
const ColoredBox(
  color: Colors.black,
  body: Glitters(),
)
```

**Multiple glitters**

```dart
SizedBox(
  width: 200.0,
  height: 200.0,
  child: Stack(
    children: const <Widget>[
      SizedBox.expand(
        child: ColoredBox(color: Colors.black),
      ),
      Glitters(
        interval: Duration(milliseconds: 300),
        maxOpacity: 0.7,
        color: Colors.orange,
      ),
      Glitters(
        duration: Duration(milliseconds: 200),
        outDuration: Duration(milliseconds: 500),
        interval: Duration.zero,
        color: Colors.white,
        maxOpacity: 0.5,
      ),
    ],
  ),
)
```

**A single static glitter**

```dart
const ColoredBox(
  color: Colors.black,
  child: SingleGlitter(
    maxWidth: 100.0,
    maxHeight: 100.0,
  ),
)
```

## Note

[Glitters](https://pub.dev/documentation/glitters/latest/glitters/Glitters-class.html) uses
[LayoutBuilder](https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html)
for obtaining the constraints to decide on drawing positions.
Make sure that it is not unconstrained to avoid related errors.
