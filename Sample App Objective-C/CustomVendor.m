//
//  CustomVendor.m
//  Sample App Objective-C
//

#import "CustomVendor.h"

@implementation CustomVendor

+ (id)shared {
    static CustomVendor *customVendor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        customVendor = [[self alloc] init];
    });
    return customVendor;
}

- (void)initializeVendor {
    NSLog(@"Didomi Sample App - Initializing custom vendor");
}

@end
