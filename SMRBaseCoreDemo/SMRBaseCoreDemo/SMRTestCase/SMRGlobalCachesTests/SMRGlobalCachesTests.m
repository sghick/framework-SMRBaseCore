//
//  SMRGlobalCachesTests.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/4/1.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRGlobalCachesTests.h"
#import "SMRUtilsCommonHeader.h"

@implementation SMRGlobalCachesTests

- (id)begin {
    [self test_CachesForUnnecessary];
    return self;
}

- (void)test_CachesForUnnecessary {
    SMRGlobalCache *cache1 = [SMRGlobalCache cacheWithName:@"AAAAAA"];
    NSString *testvalue = @"是Air Self-Defense Force，航空自卫队，是日本自卫队下面的空中武装部队。 由于训练水平较高、武器精良、技术先进，加上与美军有密切的交流，日本航空自卫队已成为东亚地区一支重要的空中武装力量，是亚洲少数装备F-15战斗机的空中武装力量之一。 编制、武器都偏重防卫，不配备具有侵略性的战略轰炸机、弹道导弹、空中加油机等。 扩展资料 日本作为一个岛国，资源匮乏和战略纵深不足是其两大战略弱点。因此，空中自卫队的两大基本目标就是远海防空及保卫海上交通线。为建立远海防空，其逐步实现了由专守防卫向积极防御的转身。截止2013年，航空自卫队共拥有5万余人，约200架F-15战斗机，13架E-2C预警机，15架CH-47J直升机，用于防空的爱国者导弹，以及数量不等的E-767预警机和F-2战斗机等。 参考资料：百度百科-日本航空自卫队 5    评论 分享 举报 tusamar 推荐于2019-10-16 展开全部 是Air Self-Defense Force，航空自卫队 由于受到二战后和平宪法的限制，其不能被称为日本空军。其主要由航空兵、防空导弹及雷达警戒部队组成。 编制、武器都偏重防卫，不配备具有侵略性的战略轰炸机、弹道导弹、空中加油机等。";
    [cache1 setObject:testvalue forKey:@"testkey1"];
    [cache1 setObject:testvalue forKey:@"testkey2"];
    [cache1 setObject:testvalue forKey:@"testkey3"];
    [cache1 setObject:testvalue forKey:@"testkey4"];
    [cache1 setObject:testvalue forKey:@"testkey5"];
    
    SMRGlobalCache *cache2 = [SMRGlobalCache cacheWithName:@"BBBBBB" unnecessary:YES];
    [cache2 setObject:testvalue forKey:@"testkey1"];
    [cache2 setObject:testvalue forKey:@"testkey2"];
    [cache2 setObject:testvalue forKey:@"testkey3"];
    [cache2 setObject:testvalue forKey:@"testkey4"];
    [cache2 setObject:testvalue forKey:@"testkey5"];
    
    UIImage *testimage = [SMRUtils createImageWithColor:[UIColor smr_deepOrangeColor] rect:CGRectMake(0, 0, 100, 200)];
    [cache1 setImage:testimage forKey:@"imagevalue1" completion:nil];
    
    SMRGlobalCache *cache3 = [SMRGlobalCache cacheWithName:@"CCCCCC" unnecessary:YES];
    [cache3 setImage:testimage forKey:@"imagevalue1" completion:nil];

    int32_t size1 = [SMRGlobalCache cacheSize];
    NSLog(@"all缓存值:%@B,%.2fMB", @(size1), size1/1024.0/1024.0);
    
    int32_t size2 = [SMRGlobalCache cacheSizeForUnnecessary];
    NSLog(@"unnecessary缓存值:%@B,%.2fMB", @(size2), size2/1024.0/1024.0);
}

@end
