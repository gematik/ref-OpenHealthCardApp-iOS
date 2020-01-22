# OpenHealthCardApp

Application for demonstrating OpenHealthCard Library functionality.

For more info, please find the low level projects
[HealthCardAccessKit](https://github.com/gematik/ref-HealthCardAccessKit) and
[HealthCardControlKit](https://github.com/gematik/ref-HealthCardControlKit/) on GitHub.

See the [Gematik GitHub IO](https://gematik.github.io/) page for a more general overview.

## Getting Started

HealthCardControlKit requires Swift 5.1.

### Setup for development

You will need [Bundler](https://bundler.io/), [XcodeGen](https://github.com/yonaskolb/XcodeGen), [Carthage](https://github.com/Carthage/Carthage)
and [fastlane](https://fastlane.tools) to conveniently use the established development environment.

1.  Update ruby gems necessary for build commands

        $ bundle install --path vendor/gems

2.  Checkout (and build) dependencies and generate the xcodeproject

        $ bundle exec fastlane setup_app

# Card Reader Provider(s)

Classes that implement `CardTerminalControllerProviderType` and extend `NSObject` can be used and found by the `CardReaderAccess.CardTerminalControllerManager`
when they are either referenced by the Target project or defined in the [CardReaderProvider.m](DemoApp/CardReaderProvider.m)