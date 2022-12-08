//
//  ViewController.m
//  Sample App Objective-C
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)showPreferencesPurposes:(UIButton *)sender {
    Didomi *didomi = [Didomi shared];
    [didomi onReadyWithCallback:^{
        [didomi showPreferencesWithController:self view:ViewsPurposes];
    }];
}

- (IBAction)showPreferencesVendors:(UIButton *)sender {
    Didomi *didomi = [Didomi shared];
    [didomi onReadyWithCallback:^{
        [didomi showPreferencesWithController:self view:ViewsVendors];
    }];
}

- (IBAction)showAd:(UIButton *)sender {
    if (self.interstitial) {
        [self.interstitial presentFromRootViewController:self];
    } else {
        NSLog(@"Didomi Sample App - Ad wasn't ready");
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    Didomi *didomi = [Didomi shared];
    
    if (@available(iOS 14, *)) {
        // Here, we show the ATT permission then the CMP notice if the user accepts the ATT permission, see:
        // https://developers.didomi.io/cmp/mobile-sdk/ios/app-tracking-transparency-ios-14#show-the-att-permission-then-the-cmp-notice-if-the-user-accepts-the-att-permission
        // You may want to show the CMP notice then the ATT permission if the user gives consent in the CMP notice instead, see:
        // https://developers.didomi.io/cmp/mobile-sdk/ios/app-tracking-transparency-ios-14#show-the-cmp-notice-then-the-att-permission-if-the-user-gives-consent-in-the-cmp-notice
        // You may also want to show the CMP notice whatever the ATT status
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            switch(status) {
                case ATTrackingManagerAuthorizationStatusAuthorized:
                    // Show the Didomi CMP notice to collect consent from the user
                    [didomi setupUIWithContainerController:self];
                    break;
                case ATTrackingManagerAuthorizationStatusDenied:
                    // The user denied ATT permission, deny user consent for all purposes/vendors in the Didomi CMP as well
                    [didomi setUserDisagreeToAll];
                    break;
                case ATTrackingManagerAuthorizationStatusRestricted:
                    // ATT is restricted on the device so the user was not asked for a choice (https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanager/authorizationstatus/restricted)
                    // Show the Didomi CMP notice to collect consent from the user
                    [didomi setupUIWithContainerController:self];
                    break;
                case ATTrackingManagerAuthorizationStatusNotDetermined:
                    // This is not supposed to happen
                    // Show the Didomi CMP notice to collect consent from the user
                    [didomi setupUIWithContainerController:self];
                    break;
            }
        }];
    } else {
        // Show the Didomi CMP notice to collect consent from the user as iOS < 14 (no ATT available)
        [didomi setupUIWithContainerController:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Didomi *didomi = [Didomi shared];
    
    [didomi onReadyWithCallback:^{
        [self loadAd];
        
        DDMEventListener *didomiEventListener = [[DDMEventListener alloc] init];
        
        [didomiEventListener setOnConsentChanged:^(enum DDMEventType event) {
            // The consent status of the user has changed
            [self loadAd];
        }];
        [didomi addEventListenerWithListener:didomiEventListener];
    }];
}

- (void)loadAd {
    GADRequest *request = [GADRequest request];
    [GADInterstitialAd loadWithAdUnitID:@"ca-app-pub-3940256099942544/4411468910"
                                request:request
                      completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
            self.interstitial = nil; // Will reset the cached ad (when error is `No ad to show`)
            NSLog(@"Didomi Sample App - Failed to load interstitial ad with error: %@", [error localizedDescription]);
            return;
        }
        self.interstitial = ad;
        self.interstitial.fullScreenContentDelegate = self;
    }];
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"Didomi Sample App - Ad did fail to present full screen content.");
}

/// Tells the delegate that the ad will present full screen content.
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"Didomi Sample App - Ad will present full screen content.");
    self.interstitial = nil;
    [self loadAd];
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"Didomi Sample App - Ad did dismiss full screen content.");
}


@end
