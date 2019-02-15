//
//  SMRUtils+Locations.m
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/15.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils+Locations.h"

@implementation SMRUtils (Locations)

//+ (double)calulateDistanceWithStartLatitude:(double)start_latitude
//                                  longitude:(double)start_longitude
//                                endLatitude:(double)end_latitude
//                               andLongitude:(double)end_longitude {
//    double a = DEGREES_TO_RADIANS(start_latitude) - DEGREES_TO_RADIANS(end_latitude);
//    double b = DEGREES_TO_RADIANS(start_longitude) - DEGREES_TO_RADIANS(end_longitude);
//    double s = 2 * sin(sqrt(pow(sin(a/2),2) + cos(DEGREES_TO_RADIANS(start_latitude))*cos(DEGREES_TO_RADIANS(end_latitude))*pow(sin(b/2),2)));
//    s = s * EARTH_RADIUS;
//    s = round(s * 10000) / 10000;
//    return s;
//}

@end
