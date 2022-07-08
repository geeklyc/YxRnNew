//
//  ARNBridgeLoader.m
//  YxRnNew
//
//  Created by liyoucheng on 2022/7/4.
//  Copyright © 2022 geeklyc. All rights reserved.
//

#import "ARNBridgeLoader.h"

#import "RCTBridge+ARNBridge.h"
#import <React/RCTBridge+Private.h>

@interface ARNBridgeLoader ()

@property (nonatomic, strong, readwrite) RCTBridge *bridge;
@property (nonatomic, copy) ARNLoadCompletionBlock completionBlock;
@property (nonatomic, strong) NSMutableArray *loadedScriptMArray; ///< 已经加载的脚本

@end

@implementation ARNBridgeLoader

- (instancetype)initWithDevHost:(NSString *)devHost ompleteion:(ARNLoadCompletionBlock)completed {
    self = [super init];
    if (self) {
        [self addDidLoadNotification];
        
        self.completionBlock = completed;
        NSLog(@"【RN】加载基础包：%@", devHost);
        self.bridge = [[RCTBridge alloc] initWithBundleURL:[self generateJsCodeLocation:devHost] moduleProvider:nil launchOptions:nil];
    }
    return self;
}

// MARK: - public methods

- (void)loadScriptWithPath:(NSString *)path completeion:(ARNLoadCompletionBlock)completed {
    NSLog(@"【RN】加载业务包：%@", path);
    
    if (!completed) {
        return;
    }
    
    if ([self.loadedScriptMArray containsObject:path]) {
        completed();
        return;
    }
    
    self.completionBlock = completed;
    NSError *error = nil;
    NSData *businessSource = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
    if (error) {
        completed();
        return;
    }
    
    NSLog(@"【RN】执行业务代码：%@", path);
    [self.bridge.batchedBridge executeSourceCode:businessSource sync:NO];
    [self.loadedScriptMArray addObject:path];
}

- (BOOL)isLoadedScriptWithPath:(NSString *)path {
    return [self.loadedScriptMArray containsObject:path];
}

// MARK: - private methods

- (NSURL *)generateJsCodeLocation:(NSString *)devHost {
    NSURL *jsCodeLocation;
    if (devHost && [devHost length] > 0) {
        jsCodeLocation = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/index.bundle?platform=ios&dev=true&minify=false", devHost]];
    } else {
        // 加载基础包
        jsCodeLocation = [[NSBundle bundleForClass:[ARNBridgeLoader class]] URLForResource:@"common.ios" withExtension:@"bundle"];
    }
    return jsCodeLocation;
}

- (void)addDidLoadNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(javaScriptDidLoad:) name:RCTJavaScriptDidLoadNotification object:nil];
}

// MARK: - event response

- (void)javaScriptDidLoad:(NSNotification *)noti {
    RCTBridge *bridge = (RCTBridge *)noti.object;
    if (bridge != self.bridge) {
        return;
    }
    
    if (!self.completionBlock) {
        return;
    }
    
    // 只执行一次
    ARNLoadCompletionBlock completion = [self.completionBlock copy];
    self.completionBlock = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completion();
    });
}

// MARK: - getters or setters

- (NSMutableArray *)loadedScriptMArray {
    if (!_loadedScriptMArray) {
        _loadedScriptMArray = [NSMutableArray array];
    }
    return _loadedScriptMArray;
}

@end
