# Glitters

A glittering widget for Flutter.

![Screencast](https://user-images.githubusercontent.com/20254485/83968159-29878f00-a902-11ea-8c95-320154181eb6.gif)

## What it does

This package provides two types of widgets:

* Glitters
    * The main widget of this package that fades in and out glitter-like shapes one by one inside itself.
* SingleGlitter
    * An extra widget to draw a single static glitter-like shape.

## Note

Glitters uses [LayoutBuilder](https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html)
for obtaining the constraints to decide on drawing positions.
Make sure that it is not unconstrained to avoid related errors.
