//
//  ARNRouteInfo.m
//  YxRnNew
//
//  Created by liyoucheng on 2022/6/6.
//  Copyright © 2022 geeklyc. All rights reserved.
//

#import "ARNRouteInfo.h"

@implementation ARNRouteInfo

- (NSString *)description {
    return [NSString stringWithFormat:@"key=%@，bundleName=%@，component=%@，debug=%@, action=%@，devHost=%@", self.key, self.bundleName, self.componentName, @(self.isDebug), self.action, self.devHost];
}

@end
