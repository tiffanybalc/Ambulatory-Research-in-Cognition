# README #

Usage Notes
----

The current version of this application is written in Swift 4, confirmed to work in XCode 9.1-9.4
There are several Schemes setup, which specialize functionality for different versions of this application (both production and QA versions of TU,CS, and EXR).

Dependencies
----

This application uses [CocoaPods](https://cocoapods.org/) as a dependency manager. Currently it only uses [Zip](https://github.com/marmelroy/Zip) to handle creating zip files.

Debug/Production Flags
----

There are several flags you can set to enable or disable certain functionality:
- DNRestAPI.storeZips: if true, it will store zips in the app's Documents folder
- DNRestAPI.sendData: if false, this will not attempt to send any data; all data calls will act as if they've succeeded. If you want to disable verification of Participant ID or Rater ID, you should set this to false.
- DNRestAPI.dontRandomize: If set to true, the three tests will always run in the same order.
- DNLogManager.logToFile: If true, calls to DNLog() will also be logged to a file in the app's Documents folder.

We recommend setting these flags at application startup, in applicationDidFinishLaunchingWithOptions.


