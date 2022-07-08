//
//  ARNRootViewFactory.m
//  YxRnNew
//
//  Created by liyoucheng on 2022/7/5.
//  Copyright © 2022 geeklyc. All rights reserved.
//

#import "ARNRootViewFactory.h"

#import "ARNRouteParser.h"

@implementation ARNRootViewFactory

+ (ARNRootView *)createRootView:(NSString *)url {
    ARNRouteInfo *routeInfo = [[ARNRouteParser new] parserUrlHandler:url];
    if (!routeInfo) {
        return nil;
    }
    
    ARNRootView *rootView = [[ARNRootView alloc] initWithRouteInfo:routeInfo];
    return rootView;
}

@end
