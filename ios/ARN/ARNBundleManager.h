//
//  ARNBundleManager.h
//  YxRnNew
//
//  Created by liyoucheng on 2022/7/7.
//  Copyright © 2022 geeklyc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARNBundleManager : NSObject

+ (instancetype)sharedInstance;

/// 解压资源+合并图片
/// @param bundleName 包名
- (void)start:(NSString *)bundleName;

/// 获取包的路径
/// @param bundleName 包名
- (NSString *)fetchBundlePath:(NSString *)bundleName;

/// 获取图片的路径
/// @param bundleName 包名
- (NSString *)fetchAssetsPath:(NSString *)bundleName;

@end

NS_ASSUME_NONNULL_END
