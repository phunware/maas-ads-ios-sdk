MaaS Advertising iOS SDK
================

Version 4.0.4

Overview
------------
This is Phunware's iOS SDK for the MaaS Advertising module. Visit https://ssp-portal.phunware.com for more details and to sign up.

Requirements
------------
* iOS 10.1 or greater
* Xcode 8.1 or greater
* Swift 4.1 or 4.2

Installation
------------
### CocoaPods
Phunware recommends using [CocoaPods](http://www.cocoapods.org) to integrate the framework. To integrate PWAds into your Xcode project using CocoaPods, specify it in your `Podfile`:
~~~
pod 'PWAds'
~~~

Usage
----------

### Banners

Banners will be displayed immediately once they are returned from Phunware’s ad server.  

The response functions are included in a closure passed to the placement request.

**Creating a banner**

* PWBanner(placement, parentViewController, position)
  * placement (currently, only one placement should be returned from Phunware, but in the future a list may be returned.  For now, only placement[0] will ever be used.
  * parentViewController (This is the containing controller that should house the banner.  Typically this will be the view controller doing the banner request)
  * position (A string constant noting where the banner should appear on screen.  Positions values can be found in Phunware.MRAIDConstants)

**Retrieving a banner**

Width and height are optional here.  Most of the time the width and height will come from the zone in your Phunware configuration but if that is not set, you may want to set a fallback here.

~~~Swift
let config = PlacementRequestConfig(accountId: <accountId>, zoneId: <zoneId>, width:320, height:50, customExtras:nil)
Phunware.requestPlacement(with: config) { response in
    switch response {
    case .success(_ , let placements):
        guard placements.count == 1 else {
            // error
            return
        }
        guard placements[0].isValid else {
            // error
            return
        }
        self.banner = PWBanner(placement:placements[0], parentViewController:self, position:Positions.BOTTOM_CENTER)
    case .badRequest(let statusCode, let responseBody):
        return
    case .invalidJson(let responseBody):
        return
    case .requestError(let error):
        return
    }
}
~~~

### Interstitial

Your view controller  will need to implement the PWInterstitialDelegate interface to retrieve event information.

These methods are:

~~~Swift
func interstitialReady(_ interstitial: PWInterstitial) {
     print("ready");
}

func interstitialFailedToLoad(_ interstitial: PWInterstitial) {
    print("failed");
}

func interstitialClosed(_ interstitial: PWInterstitial) {
    print("close");
}

func interstitialStartLoad(_ interstitial: PWInterstitial) {
    print("start load");
}
~~~

**Retrieving an interstitial**

~~~Swift
let config = PlacementRequestConfig(accountId: <accountId>, zoneId: <zoneId>, width:nil, height:nil, customExtras:nil)
Phunware.requestPlacement(with: config) { response in
    switch response {
    case .success(_ , let placements):
        guard placements.count == 1 else {
            return  // interstitials should currently only return a single ad
        }
        guard placements[0].isValid else {
            return
        }
        if(placements[0].body != nil && placements[0].body != ""){
            self.interstitial = PWInterstitial(placement:placements[0], parentViewController:self, delegate:self, respectSafeAreaLayoutGuide:true)
        }
    default:
        return
    }
}
~~~

**Creating an Interstitial**

* PWInterstitial(placement, parentViewController, delegate, respectSafeAreaLayoutGuide)
  * placement (as with banners, currently only one placement will be returned from Phunware)
  * parentViewController (The view controller which will contain the interstitial, typically the same controller that retrieves the interstitial placement)
  * delegate (A class that implements the PWInterstitialDelegate interface.  Typically the view controller which retrieves the interstitial)
  * respectSafeAreaLayoutGuide (Some apps may choose to have their layout take into account the safe area layout guide in order to have the status bar showing.  If your app does this, then this setting will tell the interstitial to do the same)

Once retrieved, the interstitialReady function will be called.  After this point you can display the interstitial at any time with:

~~~Swift
interstitial.display()
~~~

The interstitial can only been displayed once, after which you must retrieve another one.

Sample
-----------
To use the included Sample, navigate to the Samples/Sample directory in Terminal and execute a `pod update` command. Once the installation is complete, open `Sample.xcworkspace` in Xcode.

Privacy
-----------
You understand and consent to Phunware’s Privacy Policy located at www.phunware.com/privacy. If your use of Phunware’s software requires a Privacy Policy of your own, you also agree to include the terms of Phunware’s Privacy Policy in your Privacy Policy to your end users.

Terms
-----------
Use of this software requires review and acceptance of our terms and conditions for developer use located at http://www.phunware.com/terms/
