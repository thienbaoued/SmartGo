# Scooter iOS

## How to setup

Environments and tools:
----------------------

Xcode 10 or later

Carthage 0.32.0

Cocoapods 1.6.0.beta.2

Swiftlint 0.31.0

Swift 4.2

Development Target: iOS 10

Required:
-------

Installing the following packages:

[Cocoapods](https://cocoapods.org/) : `sudo gem install cocoapods`

[Carthage](https://github.com/Carthage/Carthage) : `brew update & brew install carthage`

[Swiftlint](https://github.com/realm/SwiftLint) : `brew install swiftlint`

Setup:
-----

* Before setting the project up, you must ensure that all above requirements were up already.

. Clone the repository to your machine

. Update Carthage: 
`carthage bootstrap --platform iOS --no-use-binaries`

. Install pods: 
`pod install`

Getting Started:
---------------

. Architecture: CleanArtichect-MVVM.

. Code commentation followed Apple standard style.

. In order to make the project going perfect with CleanArtchitect-MVVM architecture, `RxSwift` was preferred to use for binding data and UIs control.

. The project was integrated `SwiftLint` for Swift style and conventions enforcement. All rules were declared in .swiftlint.yml file.

Document Generator:
---------
[Jazzy](https://github.com/realm/jazzy) - A command-line utility that generates documentation for Swift.

#### Install: `sudo gem install jazzy`

. Issue the following command to generate the project's documentation.

````
sh doc.sh
````

Frameworks:
----------

. [RxSwift](https://github.com/ReactiveX/RxSwift) - Reactive programming in Swift.

. [Alamofire](https://github.com/Alamofire/Alamofire) - Alamofire is an HTTP networking library written in Swift.

. [Kingfisher](https://github.com/onevcat/Kingfisher) - A lighweight, pure-Swift library for downloading and caching images from the web.

. [SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver) - Convenient logging during development & release.

. [SwiftDate](https://github.com/malcommac/SwiftDate) - The best way to manage Dates and Timezones in Swift
