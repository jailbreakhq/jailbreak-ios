Jailbreak iOS App
================

Development
------------------

###3rd Party Frameworks

- [**AFNetworking**](http://github.com/AFNetworking/AFNetworking)
- [**SDWebImage**](https://github.com/rs/SDWebImage)
- [**SVPullToRefresh**](https://github.com/samvermette/SVPullToRefresh)
- [**JTSImageViewController**](https://github.com/jaredsinclair/JTSImageViewController)
- [**XCDYouTubeKit**](https://github.com/0xced/XCDYouTubeKit)
- [**BSKeyboardControls**](https://github.com/simonbs/BSKeyboardControls)
- [**SpinKit**](https://github.com/raymondjavaxx/SpinKit-ObjC)
- [**TPKeyboardAvoiding**](https://github.com/michaeltyson/TPKeyboardAvoiding)
- [**JTSHardwareInfo**](https://github.com/jaredsinclair/JTSHardwareInfo)
- [**DateTools**](https://github.com/MatthewYork/DateTools)
- [**SAMRateLimit**](https://github.com/soffes/SAMRateLimit)
- [**TSMessages**](https://github.com/Shayanzadeh/TSMessages)
- [**TTTAttributedLabel**](https://github.com/TTTAttributedLabel/TTTAttributedLabel)

###Installing Dependencies

[**CocoaPods**](http://cocoapods.org/) will handle all the work for us.  
First install it by typing into terminal:

```bash
sudo gem install cocoapods
```

Then in terminal `cd` to the project folder (were .xcodeproj is) and run:

```bash
pod install
```

Update existing frameworks by running:

```bash
pod update
```
  
***NOTE: You MUST open .xcworkspace instead of .xcodeproj from now on.***