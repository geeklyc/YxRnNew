//
//  ARNAssetEmitter.m
//  YxRnNew
//
//  Created by liyoucheng on 2022/7/5.
//  Copyright © 2022 geeklyc. All rights reserved.
//

#import "ARNAssetEmitter.h"

#import "ARNCommonDefine.h"

@implementation ARNAssetEmitter
{
    BOOL hasListeners;
}

RCT_EXPORT_MODULE();

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bundleLoaded:) name:kARNAssetEmitterBundleAssetWillChangeNotificationKey object:nil];
    }
    return self;
}

- (NSArray<NSString *> *)supportedEvents {
  return @[ @"ARNBundleLoad" ];
}

- (void)bundleLoaded:(NSNotification *)notification {
    if (hasListeners) {
        NSString *path = notification.userInfo[@"path"];
        [self sendEventWithName:@"ARNBundleLoad" body:@{ @"path": path}];
    }
}

- (void)startObserving {
    hasListeners = YES;
}

- (void)stopObserving {
    hasListeners = NO;
}

@end
