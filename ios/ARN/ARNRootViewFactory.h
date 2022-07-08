//
//  ARNRootViewFactory.h
//  YxRnNew
//
//  Created by liyoucheng on 2022/7/5.
//  Copyright © 2022 geeklyc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ARNRootView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARNRootViewFactory : NSObject

+ (ARNRootView *)createRootView:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
