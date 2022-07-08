//
//  ARNRouteParser.m
//  YxRnNew
//
//  Created by liyoucheng on 2022/6/6.
//  Copyright © 2022 geeklyc. All rights reserved.
//

#import "ARNRouteParser.h"

static NSString *ARNRouteParserSchemeName = @"pai";

@implementation ARNRouteParser
// * 零次或多次
// + 一次或多次
// [^/] 不匹配括号中字符
// . 除 \n 所有字符
// ? 匹配零次或一次

// pai://test/aPage?_debug=true&_devHost=192.168.92.225:8081&name=geeklyc&age=18

- (ARNRouteInfo *)parserUrlHandler:(NSString *)urlString {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(.*?)://([^/]+)/([^?]*)(?:\\?(.*))?$" options:NSRegularExpressionUseUnicodeWordBoundaries error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
    if (!match) {
        NSLog(@"【RN】路由解析-协议不合法：%@", urlString);
        return nil;
    }
    
    // 协议名
    if (1 >= match.numberOfRanges) {
        NSLog(@"【RN】路由解析-协议不合法：%@", urlString);
        return nil;
    }
    
    NSString *schemeName = [urlString substringWithRange:[match rangeAtIndex:1]];
    if (![schemeName isEqualToString:ARNRouteParserSchemeName]) {
        NSLog(@"【RN】路由解析-协议不合法：%@", urlString);
        return nil;
    }
    
    ARNRouteInfo *routeInfo = [ARNRouteInfo new];
    
    // 包名
    if (2 < match.numberOfRanges) {
        NSString *bundleName = [urlString substringWithRange:[match rangeAtIndex:2]];
        routeInfo.bundleName = bundleName;
    }
    
    // 组件名
    if (3 < match.numberOfRanges) {
        NSString *path = [urlString substringWithRange:[match rangeAtIndex:3]];
        NSArray *paths = [self parserPath:path];
        if ([paths count] > 0) {
            routeInfo.componentName = [paths firstObject];
        }
    }
    
    // 参数
    if (4 < match.numberOfRanges) {
        NSString *query = [urlString substringWithRange:[match rangeAtIndex:4]];
        NSDictionary *querys = [self parserQuery:query];
        routeInfo.action = @{
            @"params": querys
        };
        
        for (NSString *key in [querys allKeys]) {
            if ([key isEqualToString:@"_debug"]) {
                routeInfo.debug = querys[key];
            }
            
            if ([key isEqualToString:@"_devHost"]) {
                routeInfo.devHost = querys[key];
            }
        }
    }
    
    NSLog(@"【RN】路由解析成功：%@", routeInfo);
    return routeInfo;
}

// 解析路径
- (NSArray *)parserPath:(NSString *)path {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"/?([^/]+)/?" options:NSRegularExpressionUseUnicodeWordBoundaries error:&error];
    NSArray *matches = [regex matchesInString:path options:0 range:NSMakeRange(0, [path length])];
    
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        if (match.numberOfRanges <= 0) {
            continue;
        }
        [mArray addObject:[path substringWithRange:[match rangeAtIndex:1]]];
    }
    return [mArray copy];
}

// 解析参数
- (NSDictionary *)parserQuery:(NSString *)query {
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([^=&]+)=([^&]+)" options:NSRegularExpressionUseUnicodeWordBoundaries error:&error];
    NSArray *matches = [regex matchesInString:query options:0 range:NSMakeRange(0, [query length])];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    for (NSTextCheckingResult *match in matches) {
        if (match.numberOfRanges <= 2) {
            continue;
        }
        
        NSString *key = [query substringWithRange:[match rangeAtIndex:1]];
        NSString *value = [query substringWithRange:[match rangeAtIndex:2]];
        mDict[key] = value;
    }
    return [mDict copy];
}

@end
