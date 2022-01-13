[![Pub Version](https://img.shields.io/pub/v/glitters)](https://pub.dev/packages/glitters)

A glittering widget for Flutter.

![Screencast](https://user-images.githubusercontent.com/20254485/109614952-a6385880-7b76-11eb-8691-b1f2461f2d60.gif)

## What it does

This package provides three widgets:

* [Glitters](https://pub.dev/documentation/glitters/latest/glitters/Glitters-class.html)
    * The main widget of this package that fades in and out glitter-like shapes one by one
    inside itself. This is useful when you want some part of your app to look shiny.
* [GlitterStack](https://pub.dev/documentation/glitters/latest/glitters/GlitterStack-class.html)
    * A widget used to show multiple glitters by stacking them.
* [SingleGlitter](https://pub.dev/documentation/glitters/latest/single_glitter/SingleGlitter-class.html)
    * A widget to show a single static glitter-like shape.

## Code examples

**Simplest**

```dart
Container(
  width: 200.0,
  height: 200.0,
  color: Colors.black,
  child: const Glitters(),
)
```

**Multiple glitters**

With `Stack`:

```dart
SizedBox(
  width: 200.0,
  height: 200.0,
  child: ColoredBox(
    color: Colors.black,
    child: Stack(
      children: const [
        Glitters(
          duration: Duration(milliseconds: 200),
          interval: Duration.zero,
          color: Colors.orange,
          maxOpacity: 0.7,
        ),
        Glitters(
          duration: Duration(milliseconds: 200),
          interval: Duration.zero,
          delay: Duration(milliseconds: 100),
          color: Colors.white,
          maxOpacity: 0.7,
        ),
      ],
    ),
  ),
)
```

With `GlitterStack`:

```dart
const GlitterStack(
  width: 200.0,
  height: 200.0,
  backgroundColor: Colors.black,
  // You can set common settings for multiple glitters.
  duration: Duration(milliseconds: 200),
  interval: Duration.zero,
  color: Colors.white,
  maxOpacity: 0.7,
  children: [
    Glitters(
      color: Colors.orange,
    ),
    Glitters(
      delay: Duration(milliseconds: 100),
    ),
  ],
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
