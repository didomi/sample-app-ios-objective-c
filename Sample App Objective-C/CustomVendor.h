//
//  CustomVendor.h
//  Sample App Objective-C
//

#import <foundation/Foundation.h>

#ifndef CustomVendor_h
#define CustomVendor_h

@interface CustomVendor : NSObject {
    
}

+ (id)shared;
- (void)initializeVendor;

@end

#endif /* CustomVendor_h */
