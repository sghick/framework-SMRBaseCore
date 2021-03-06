//
//  SMRLineLayout.m
//  SMRBaseCoreDemo
//
//  Created by Tinswin on 2020/3/19.
//  Copyright © 2020 sumrise. All rights reserved.
//

#import "SMRLineLayout.h"

@implementation SMRLineLayoutItem

@end

@interface SMRLineLayout ()

@property (strong, nonatomic) NSMutableDictionary<NSNumber *, SMRLineLayoutItem *> *caches;
@property (strong, nonatomic) NSLock *lock;

@end

@implementation SMRLineLayout

- (SMRLineLayoutItem *)itemWithLayoutIndex:(NSInteger)index {
    SMRLineLayoutItem *item = self.caches[@(index)];
    if (item) {
        return item;
    } else {
        [self layoutToIndex:index process:nil];
        return [self itemWithLayoutIndex:index];
    }
}

- (void)clearCache {
    _caches = nil;
}

- (void)clearCacheFromIndex:(NSInteger)fromIndex {
    for (NSInteger i = fromIndex; i < _caches.allKeys.count; i++) {
        _caches[@(i)] = nil;
    }
}

- (void)layoutToIndex:(NSInteger)index process:(nullable void (^)(NSInteger, SMRLineLayoutItem * _Nonnull))process {
    [self layoutWithinRange:NSMakeRange(0, index + 1) process:process];
}

- (void)layoutWithinRange:(NSRange)range process:(nullable void (^)(NSInteger, SMRLineLayoutItem * _Nonnull))process {
    if (!range.length) {
        return;
    }
    if (!self.itemBlock) {
        return;
    }
    
    // 判断是否存在上一个
    if (!range.location && ![self.caches.allKeys containsObject:@(range.location - 1)]) {
        [self layoutWithinRange:NSMakeRange(range.location - 1, 1) process:nil];
    }
    
    for (NSUInteger i = range.location; i < (range.length - range.location); i++) {
        SMRLineLayoutItem *lastItem = (i > 0) ? self.caches[@(i - 1)] : nil;
        SMRLineLayoutItem *item = self.caches[@(i)];
        if (item) {
            if (process) {
                process(i, item);
            }
            continue;
        }
        CGSize cSize = self.itemBlock(self, i);
        item = [self itemWithIndex:i size:cSize lastItem:lastItem];
        self.caches[@(i)] = item;
        if (process) {
            process(i, item);
        }
    }
}

#pragma mark - Utils

- (SMRLineLayoutItem *)itemWithIndex:(NSInteger)index size:(CGSize)size lastItem:(SMRLineLayoutItem *)lastItem {
    SMRLineLayoutItem *item = [[SMRLineLayoutItem alloc] init];
    item.index = index;
    // 如果是第0个,直接计算出结果
    if (!index) {
        item.position = CGPointZero;
        // 如果当前item的宽超过最大值,做出限制
        CGFloat maxWith = self.maxSize.width - self.contentInset.left - self.contentInset.right;
        if (size.width > maxWith) {
            item.frame = CGRectMake(self.contentInset.left, self.contentInset.top, maxWith, size.height);
        } else {
            item.frame = CGRectMake(self.contentInset.left, self.contentInset.top, size.width, size.height);
        }
        return item;
    }

    if (index && !lastItem) {
        NSAssert(NO, @"[SMRLineLayout] lastItem 不能为空");
    }
    
    // 计算x的起点
    CGFloat originX = lastItem.frame.origin.x + lastItem.frame.size.width + self.sep.width;
    if (originX <= (self.maxSize.width - size.width - self.contentInset.right)) {
        // 同一行能展示完全
        item.position = CGPointMake(lastItem.position.x, lastItem.position.y + 1);
        item.frame = CGRectMake(originX, lastItem.frame.origin.y, size.width, size.height);
    } else {
        // 换行处理
        item.position = CGPointMake(lastItem.position.x + 1, 0);
        CGFloat originY = lastItem.frame.origin.y + lastItem.frame.size.height + self.sep.height;
        // 如果当前item的宽超过最大值,做出限制
        CGFloat maxWith = self.maxSize.width - self.contentInset.left - self.contentInset.right;
        if (size.width > maxWith) {
            item.frame = CGRectMake(self.contentInset.left, originY, maxWith, size.height);
        } else {
            item.frame = CGRectMake(self.contentInset.left, originY, size.width, size.height);
        }
    }
    return item;
}

#pragma mark - Getters

- (NSMutableDictionary<NSNumber *,SMRLineLayoutItem *> *)caches {
    if (!_caches) {
        _caches = [NSMutableDictionary dictionary];
    }
    return _caches;
}

@end
