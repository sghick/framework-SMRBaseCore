//
//  SMRUtils+Locations.h
//  SMRBaseCoreDemo
//
//  Created by 丁治文 on 2019/2/15.
//  Copyright © 2019 sumrise. All rights reserved.
//

#import "SMRUtils.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 坐标在线：http://www.gpsspg.com/maps.htm
 上面找到的是火星坐标,需要使用对应的方法转成真实GPS
 
 坐标系：
 WGS-84：是国际标准，GPS坐标（Google Earth使用、或者GPS模块）
 GCJ-02：中国坐标偏移标准，Google Map、高德、腾讯使用
 BD-09 ：百度坐标偏移标准，Baidu Map使用
 */
@interface SMRUtils (Locations)

///** 计算2个坐标间的直线距离 */
//+ (double)calulateDistanceWithStartLatitude:(double)start_latitude
//                                  longitude:(double)start_longitude
//                                endLatitude:(double)end_latitude
//                               andLongitude:(double)end_longitude;

/** 从GPS坐标转化到高德坐标 */
+ (CLLocationCoordinate2D)transformFromGPSToGDWithCoordinate:(CLLocationCoordinate2D)coordinate;

/** 从高德坐标转化到百度坐标 */
+ (CLLocationCoordinate2D)transformFromGDToBDWithCoordinate:(CLLocationCoordinate2D)coordinate;

/** 从百度坐标到高德坐标 */
+ (CLLocationCoordinate2D)transformFromBDToGDWithCoordinate:(CLLocationCoordinate2D)coordinate;

/** 从高德坐标到GPS坐标 */
+ (CLLocationCoordinate2D)transformFromGDToGPSWithCoordinate:(CLLocationCoordinate2D)coordinate;

/** 从百度坐标到GPS坐标 */
+ (CLLocationCoordinate2D)transformFromBDToGPSWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end

NS_ASSUME_NONNULL_END
