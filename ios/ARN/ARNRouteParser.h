//
//  ARNRouteParser.h
//  YxRnNew
//
//  Created by liyoucheng on 2022/6/6.
//  Copyright © 2022 geeklyc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ARNRouteInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARNRouteParser : NSObject

- (ARNRouteInfo *)parserUrlHandler:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
