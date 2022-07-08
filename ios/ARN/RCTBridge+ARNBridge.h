//
//  RCTBridge+ARNBridge.h
//  YxRnNew
//
//  Created by liyoucheng on 2022/7/4.
//  Copyright © 2022 geeklyc. All rights reserved.
//

#import <React/RCTBridge.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCTBridge (ARNBridge)

// 暴露 RCTBridge 私有方法提供 RN 分包加载
- (void)executeSourceCode:(NSData *)sourceCode sync:(BOOL)sync;

@end

NS_ASSUME_NONNULL_END

