## 0.4.0

- Add .icon and .widget constructors to `Glitters`. (#12)

## 0.3.4

- Fix LateInitializationError. (#7)
- Ensure that a glitter with a delay is shown even if the delay is very small. (#9)
- Fix broken links in the document of `SingleGlitter`.
- Change the theme color of the example app.

## 0.3.3

- Prevent invalid duration values and related errors.
- Fix issue of using properties sometimes before they are lazily initialised.

## 0.3.2

- Fix issue where values set in Glitters were overwritten by those set in GlitterStack.
- Fix issue of delay disappearing once app goes to background. (#3)
- Refactoring of glitters.dart.

## 0.3.1

- Minor fixes.

## 0.3.0

- Add `delay` to `Glitters`.
- Add `GlitterStack` widget.
- Prevent glitters offsets from being changed by rebuilds.
- Remove dependency on meta.

## 0.2.0

- Migrate to null safety.

## 0.1.5

- Fix wrong size of `SingleGlitter`. (#1)
- **BREAKING CHANGE**
    - Remove `size` from SingleGlitter and add `maxWidth` and `maxHeight` instead.

## 0.1.4

- Change minimum SDK version to 2.9.0 to be compatible with the latest Flutter version.
- Update linter rules and change code accordingly (mainly removal of local variable types).

## 0.1.3

- Update documentation.
- Tweak circle size.

## 0.1.2

- Tweak minimum cross width.
- Improve gradient/opacity of inner whitish circle.
- Enable durations to be updated by hot reload. 

## 0.1.1

- Improve handling of default sizes.
- Update README.

## 0.1.0

- Release as a public package.

## 0.0.2

- More real look with better shape and gradient.

## 0.0.1

- Initial release
