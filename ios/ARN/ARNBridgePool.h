//
//  ARNBridgePool.h
//  YxRnNew
//
//  Created by liyoucheng on 2022/7/4.
//  Copyright © 2022 geeklyc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ARNRouteInfo.h"
#import "ARNCommonDefine.h"
#import "ARNBridgeLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARNBridgePool : NSObject

- (ARNBridgeLoader *)fetchLoaderWithEntryInfo:(ARNRouteInfo *)entryInfo completion:(ARNLoadCompletionBlock)completed;

@end

NS_ASSUME_NONNULL_END
