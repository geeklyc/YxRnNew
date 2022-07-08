//
//  ARNBridgeLoader.h
//  YxRnNew
//
//  Created by liyoucheng on 2022/7/4.
//  Copyright © 2022 geeklyc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <React/RCTBridge.h>

#import "ARNCommonDefine.h"

NS_ASSUME_NONNULL_BEGIN


@interface ARNBridgeLoader : NSObject

@property (nonatomic, strong, readonly) RCTBridge *bridge;

// 初始化
- (instancetype)initWithDevHost:(NSString *)devHost ompleteion:(ARNLoadCompletionBlock)completed;

// 加载业务包
- (void)loadScriptWithPath:(NSString *)path completeion:(ARNLoadCompletionBlock)completed;

// 是否已经加载
- (BOOL)isLoadedScriptWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
