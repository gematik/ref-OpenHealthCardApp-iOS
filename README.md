[![No Maintenance Intended](http://unmaintained.tech/badge.svg)](http://unmaintained.tech/)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-no-red.svg)](https://bitbucket.org/lbesson/ansi-colors)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# OpenHealthCardApp

Application for demonstrating OpenHealthCardKit library functionality.

For more info, please find the low level project
[OpenHealthCardKit](https://github.com/gematik/ref-OpenHealthCardKit) on GitHub.

See the [Gematik GitHub IO](https://gematik.github.io/) page for a more general overview.

## Getting Started

The OpenHealthCardKit-DemoApp requires Swift 5.1.

### Setup for development

You will need [Bundler](https://bundler.io/), [XcodeGen](https://github.com/yonaskolb/XcodeGen), [Carthage](https://github.com/Carthage/Carthage)
and [fastlane](https://fastlane.tools) to conveniently use the established development environment.

1.  Update ruby gems necessary for build commands

        $ bundle install --path vendor/gems

2.  Checkout (and build) dependencies and generate the xcodeproject

        $ bundle exec fastlane setup_app

# Card Reader Provider(s)

Classes that implement `CardTerminalControllerProviderType` and extend `NSObject` can be used and found by the `CardReaderAccess.CardTerminalControllerManager`
when they are either referenced by the Target project or defined in the [CardReaderProviderLoader.m](DemoApp/CardReaderProviderLoader.m)
