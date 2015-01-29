Jailbreak iOS App
================

Development
------------------

###3rd Party Frameworks

- [**AFNetworking**](http://github.com/AFNetworking/AFNetworking)
- [**SDWebImage**](https://github.com/rs/SDWebImage)
- [**SIAlertView**](https://github.com/Sumi-Interactive/SIAlertView)
- [**SVPullToRefresh**](https://github.com/samvermette/SVPullToRefresh)
- [**JTSImageViewController**](https://github.com/jaredsinclair/JTSImageViewController)
- [**Stripe**](https://github.com/stripe/stripe-ios)
- [**PaymentKit**](https://github.com/stripe/PaymentKit)

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