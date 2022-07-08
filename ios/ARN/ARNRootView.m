//
//  ARNRootView.m
//  YxRnNew
//
//  Created by liyoucheng on 2022/7/5.
//  Copyright © 2022 geeklyc. All rights reserved.
//

#import "ARNRootView.h"

#import <React/RCTRootView.h>

#import "ARNBundleManager.h"
#import "ARNCommonDefine.h"

@interface ARNRootView ()

@property (nonatomic, strong) ARNBridgeLoader *loader;
@property (nonatomic, strong) ARNRouteInfo *routeInfo;

@end

@implementation ARNRootView

- (instancetype)initWithRouteInfo:(ARNRouteInfo *)routeInfo {
    self = [super init];
    if (self) {
        self.routeInfo = routeInfo;
        [self loadRCTView];
    }
    return self;
}

- (void)loadRCTView {
    if (self.routeInfo.debug && self.routeInfo.devHost && [self.routeInfo.devHost length] > 0) {
        // 开发环境
        self.loader = [[ARNBridgeLoader alloc] initWithDevHost:self.routeInfo.devHost ompleteion:^{
            [self initView];
        }];
    } else {
        self.loader = [[ARNBridgeLoader alloc] initWithDevHost:self.routeInfo.devHost ompleteion:^{
            [self loadJS];
        }];
    }
}

- (void)initView {
    NSDictionary *properties = @{
        @"action": self.routeInfo.action
    };
    RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:self.loader.bridge moduleName:self.routeInfo.componentName initialProperties:properties];
    rootView.frame = self.bounds;
    rootView.backgroundColor = [UIColor whiteColor];
    [self addSubview:rootView];
}

- (void)loadJS {
    [[ARNBundleManager sharedInstance] start:self.routeInfo.bundleName];
    NSString *bundlePath = [[ARNBundleManager sharedInstance] fetchBundlePath:self.routeInfo.bundleName];
    [self.loader loadScriptWithPath:bundlePath completeion:^{
        // 通知更换图片查找路径
        NSString *assetsPath = [[ARNBundleManager sharedInstance] fetchAssetsPath:self.routeInfo.bundleName];
        [[NSNotificationCenter defaultCenter] postNotificationName:kARNAssetEmitterBundleAssetWillChangeNotificationKey object:nil userInfo:@{  @"path": assetsPath ? [NSString stringWithFormat:@"file://%@", assetsPath] : @"" }];
        
        [self initView];
    }];
}

@end
