# Glitters

[![Pub Version](https://img.shields.io/pub/v/glitters)](https://pub.dev/packages/glitters)

A glittering widget for Flutter.

![Screencast](https://user-images.githubusercontent.com/20254485/109614952-a6385880-7b76-11eb-8691-b1f2461f2d60.gif)

## What it does

This package provides two types of widgets:

* [Glitters](https://pub.dev/documentation/glitters/latest/glitters/Glitters-class.html)
    * The main widget of this package that fades in and out glitter-like shapes one by one inside itself. This is useful when you want some part of your app to look shiny.
* [SingleGlitter](https://pub.dev/documentation/glitters/latest/single_glitter/SingleGlitter-class.html)
    * Just an extra widget to draw a single static glitter-like shape.

## Code examples

**Simplest**

```dart
const ColoredBox(
  color: Colors.black,
  child: Glitters(),
)
```

**Multiple glitters**

```dart
SizedBox(
  width: 200.0,
  height: 200.0,
  child: ColoredBox(
    color: Colors.black,
    child: Stack(
      children: const [
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
    aspectRatio: 0.8,
  ),
)
```
