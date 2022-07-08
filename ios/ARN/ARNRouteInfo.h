//
//  ARNRouteInfo.h
//  YxRnNew
//
//  Created by liyoucheng on 2022/6/6.
//  Copyright © 2022 geeklyc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ARNPackageLoader.h"

NS_ASSUME_NONNULL_BEGIN

// 环境信息
typedef NS_ENUM(NSUInteger, AISRouteEnv) {
    AISRouteEnvPrd = 0, ///< 生产
    AISRouteEnvStg, ///< 测试
};

@interface ARNRouteInfo : NSObject

@property (nonatomic, copy) NSString *key; ///< 唯一标识
@property (nonatomic, copy) NSString *bundleName; ///< 包名
@property (nonatomic, copy) NSString *componentName; ///< 组件名
@property (nonatomic, strong) NSDictionary *action; ///< 参数
@property (nonatomic, copy) NSString *devHost; ///< 域名
@property (nonatomic, assign, getter=isDebug) BOOL debug; ///< 是否开发模式
@property (nonatomic, strong) ARNPackageLoader *loader; ///< 包加载器

@end

NS_ASSUME_NONNULL_END
