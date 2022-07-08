//
//  ARNRootView.h
//  YxRnNew
//
//  Created by liyoucheng on 2022/7/5.
//  Copyright © 2022 geeklyc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ARNBridgeLoader.h"
#import "ARNRouteInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARNRootView : UIView

- (instancetype)initWithRouteInfo:(ARNRouteInfo *)routeInfo;

@end

NS_ASSUME_NONNULL_END
