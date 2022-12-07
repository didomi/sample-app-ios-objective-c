//
//  ViewController.h
//  Sample App Objective-C
//

#import <UIKit/UIKit.h>
#import <Didomi/Didomi.h>

@import AppTrackingTransparency;
@import GoogleMobileAds;

@interface ViewController : UIViewController<GADFullScreenContentDelegate>

@property(nonatomic, strong) GADInterstitialAd *interstitial;

@end

