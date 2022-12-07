//
//  AppDelegate.m
//  Sample App Objective-C
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    Didomi *didomi = [Didomi shared];
    DidomiInitializeParameters *parameters = [[DidomiInitializeParameters alloc] initWithApiKey: @"7dd8ec4e-746c-455e-a610-99121b4148df" // Replace with your public API key
                                                                         localConfigurationPath: nil
                                                                         remoteConfigurationURL: nil
                                                                                     providerID: nil
                                                                      disableDidomiRemoteConfig: NO
                                                                                   languageCode: nil
                                                                                       noticeID: @"DVLP9Qtd"]; // Replace with your notice ID, or remove if using domain targeting
    
    // Initialize the SDK
    [didomi initialize: parameters];
    
    // Important: views should not wait for onReady to be called.
    // You might want to execute code here that needs the Didomi SDK
    // to be initialized such us: analytics and other non-IAB vendors.
    [didomi onReadyWithCallback:^{
        // The Didomi SDK is ready to go, you can call other functions on the SDK.
        
        // Load your custom vendors in the onReady callback.
        // These vendors need to be conditioned manually to the consent status of the user.
        [self loadVendor];
    }];
    
    // Load the IAB vendors; the consent status will be shared automatically with them.
    // Regarding the Google Mobile Ads SDK, we also delay App Measurement as described here:
    // https://developers.google.com/admob/ios/eu-consent#delay_app_measurement_optional
    [GADMobileAds.sharedInstance startWithCompletionHandler:nil];
    
    return YES;
}

- (void)loadVendor {
    NSString *vendorId = @"c:customven-gPVkJxXD";
    Didomi *didomi = [Didomi shared];
    DDMUserStatus *userStatus = [didomi getUserStatus];

    // Enabled consent ids for vendors
    NSSet *enabledVendorsGlobalIDs = [[[userStatus vendors] global] enabled];
    bool isVendorEnabled = [enabledVendorsGlobalIDs containsObject:vendorId];
    
    // Remove any existing event listener
    if (self.didomiEventListener != nil) {
        [didomi removeEventListenerWithListener:self.didomiEventListener];
    }
    
    if (isVendorEnabled) {
        // We have consent for the vendor
        // Initialize the vendor SDK
        [[CustomVendor shared] initializeVendor];
    } else {
        // We do not have consent information yet
        // Wait until we get the user information
        self.didomiEventListener = [[DDMEventListener alloc] init];
        
        __weak AppDelegate *self_ = self;
        
        [self.didomiEventListener setOnConsentChanged:^(enum DDMEventType event) {
            // The consent status of the user has changed
            [self_ loadVendor];
        }];
        [didomi addEventListenerWithListener:self.didomiEventListener];
    }
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
