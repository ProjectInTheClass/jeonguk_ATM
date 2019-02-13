//
//  Geocoders.h
//  전국 ATM 찾기
//
//  Created by 홍재우, 이지호, 윤진 on 12/02/2019.
//  Copyright © 2019 CAUADC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Geocoders : NSObject

#pragma mark -- Reverse Geocoding
+ (void)AppleReverseGeocoderWithLocationCoordinates:(CLLocation*)location completion:(void (^)(NSString *fAddress))completion;
+ (void)GoogleReverseGeocoderWithLocationCoordinates:(CLLocation*)location completion:(void (^)(NSString *fAddress))completion;

#pragma mark -- Geocoding
+ (void)AppleGeocoderWithAddress:(NSString*)address completion:(void (^)(CLLocation *clocation))completion;
+ (void)GoogleGeocoderWithAddress:(NSString*)address completion:(void (^)(CLLocation *clocation))completion;

@end
