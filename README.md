# LocalSpend (Mobile App.)

Looking to discover if the value of spending local can be measured, understood and shown.

This repository contains the mobile application for the LocalSpend system. See also:

* the [Web application](https://github.com/Pear-Trading/Foodloop-Web); and
* the [server](https://github.com/Pear-Trading/Foodloop-Server).

## Table of Contents

* [Tech Stack](#tech-stack)
* [Features](#features)
* [Installation](#installation)
* [Configuration](#configuration)
* [Usage](#usage)
* [Testing](#testing)
* [Code Formatting](#code-formatting)
* [Documentation](#documentation)
* [Acknowledgments](#acknowledgements)
* [License](#license)
* [Contact](#contact)

## Technology Stack

The mobile app. is written in [Dart](https://dart.dev/).

| Technology  | Description         						| Link                |
|-------------|---------------------------------|---------------------|
| Flutter 		| Cross-platform mobile framework	| [Link][flutter]     |

[flutter]: https://flutter.dev/

## Features

This mobile app. provides:

- user authentication; and
- transaction logging.

## Installation

1. Install [Flutter](https://flutter.dev/docs/get-started/install);
1. if this is your first Flutter project, install the [Flutter SDK](https://flutter.dev/docs/get-started/test-drive);
1. set up [your editor](https://flutter.dev/docs/get-started/editor):
    - we recommend using [Android Studio](https://developer.android.com/studio).
1. add the line `flutter.sdk=⟨ path to Flutter SDK ⟩` to the file `android/local.properties`.

## Configuration

App. configuration settings are found in `pubspec.yaml`.

Build settings are found in the `android/` directory, in the `build.gradle`, `gradle.properties` and `settings.gradle` files.

## Usage

### Development

To activate debugging, add the following import statement:

```dart
import 'package:flutter/foundation.dart';
```

After that, you can generate debugging output using `debugPrint()`.

### Production

Run `flutter build apk -t lib/main_dev.dart` to generate an APK file.

## Testing

TODO

## Code Formatting

TODO

## Documentation

TODO

## Acknowledgements

LocalLoop is the result of collaboration between the [Small Green Consultancy](http://www.smallgreenconsultancy.co.uk/), [Shadowcat Systems](https://shadow.cat/), [Independent Lancaster](http://www.independent-lancaster.co.uk/) and the [Ethical Small Traders Association](http://www.lancasteresta.org/).

## License

This project is released under the [MIT license](https://mit-license.org/).

## Contact

| Name           | Link(s)           |
|----------------|-------------------|
| Mark Keating   | [Email][mkeating] |
| Michael Hallam | [Email][mhallam]  |

[mkeating]: mailto:m.keating@shadowcat.co.uk
[mhallam]: mailto:info@lancasteresta.org
