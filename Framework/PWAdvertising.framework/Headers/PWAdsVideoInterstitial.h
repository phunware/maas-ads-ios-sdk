//
//  PWAdsVideoInterstitial.h
//  PWAdvertising
//
//  Copyright © 2016 Phunware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWAdsVideoBase.h"

@class PWAdsRequest;
@protocol PWAdsVideoInterstitialDelegate;

/**
 Class for loading and presenting video interstitial advertisments.
 */
@interface PWAdsVideoInterstitial : PWAdsVideoBase

/// The delegate that implements PWAdsVideoInterstitialDelegate protocol.
@property (nonatomic, weak) id<PWAdsVideoInterstitialDelegate> delegate;

/// The current ad request object.
@property (nonatomic, readonly) PWAdsRequest *currentAdsRequest;

/**
 Request Video ad using PWAdsRequest instance.
 
 @param request The object with zone id, location and other ad information.
 */
- (void)loadAdsRequest:(PWAdsRequest *)request;

/**
 Called to present full screen video advertisment.
 
 @param contoller The view controller from which the ad should be displayed.
 @discussion This method should be called only after interstitial advertisment is loaded.
 */
- (void)presentFromViewController:(UIViewController *)contoller;

@end

/**
 A `PWAdsVideoInterstitialDelegate` is needed to receive callbacks about video ad status.
 */
@protocol PWAdsVideoInterstitialDelegate <NSObject>

@optional

/**
 Called when the adsLoader receives a video ad and is ready to play (required).
 
 @param videoInterstitial The video ad that was loaded.
 */
- (void)videoInterstitialDidLoadAd:(PWAdsVideoInterstitial *)videoInterstitial;

/**
 Called when the adsLoader finishes pre caching the video ad.
 
 @param videoInterstitial The video ad that was loaded.
 */
- (void)videoInterstitialDidFinishedPreCaching:(PWAdsVideoInterstitial *)videoInterstitial;

/**
 Called when a video interstitial fails to load ad.
 
 @param videoInterstitial The video interstitial that failed to load ad.
 @param error The error string detailing why the video ad failed to play.
 */
- (void)videoInterstitial:(PWAdsVideoInterstitial *)videoInterstitial didFailError:(NSError *)error;

/**
 Called after video interstitial is presented.
 
 @param videoInterstitial The full-screen video ad that is presented.
 */
- (void)videoInterstitialDidPresentModal:(PWAdsVideoInterstitial *)videoInterstitial;

/**
 Called before video interstitial dismisses video modal.
 
 @param videoInterstitial The video ad that finished playing.
 */
- (void)videoInterstitialWillDismissModal:(PWAdsVideoInterstitial *)videoInterstitial;

/**
 Called after video interstitial dismisses video modal.
 
 @param videoInterstitial The video ad that finished playing.
 */
- (void)videoInterstitialDidDismissModal:(PWAdsVideoInterstitial *)videoInterstitial;

/**
 Called right before the video interstitial leaves the application.
 
 @param videoInterstitial The video ad that will leave application
 */
- (void)videoInterstitialWillLeaveApplication:(PWAdsVideoInterstitial *)videoInterstitial;

@end



