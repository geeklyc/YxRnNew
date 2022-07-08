//
//  ARNBridgePool.m
//  YxRnNew
//
//  Created by liyoucheng on 2022/7/4.
//  Copyright © 2022 geeklyc. All rights reserved.
//

#import "ARNBridgePool.h"

@interface ARNBridgePool ()

@property (nonatomic, strong) NSMutableDictionary *bridgePool;

@end

@implementation ARNBridgePool

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static ARNBridgePool *pool;
    dispatch_once(&onceToken, ^{
        pool = [[ARNBridgePool alloc] init];
    });
    return pool;
}

- (ARNBridgeLoader *)fetchLoaderWithEntryInfo:(ARNRouteInfo *)entryInfo completion:(ARNLoadCompletionBlock)completed {
    NSString *key = [NSString stringWithFormat:@"%@-%@-%@", entryInfo.devHost, entryInfo.bundleName, entryInfo.componentName];
    if ([self.bridgePool.allKeys containsObject:key]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completed) {
                completed();
            }
        });
        return self.bridgePool[key];
    }
    
    self.bridgePool[key] = [[ARNBridgeLoader alloc] initWithDevHost:entryInfo.devHost ompleteion:completed];
    
    return self.bridgePool[key];
}

- (NSMutableDictionary *)bridgePool {
    if (!_bridgePool) {
        _bridgePool = [NSMutableDictionary dictionary];
    }
    return _bridgePool;
}

@end
