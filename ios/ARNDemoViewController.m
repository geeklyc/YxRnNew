//
//  ARNDemoViewController.m
//  YxRnNew
//
//  Created by liyoucheng on 2022/6/6.
//  Copyright © 2022 geeklyc. All rights reserved.
//

#import "ARNDemoViewController.h"

#import "ARNRootViewFactory.h"

#import <React/RCTBridge+Private.h>
#import <React/RCTRootView.h>
#import "RCTBridge+ARNBridge.h"

#import "SSZipArchive.h"

@interface ARNDemoViewController ()

@property (nonatomic, strong) RCTBridge *bridge;
@property (nonatomic, assign) BOOL businessLoaded; /// 业务包已经加载

@end

@implementation ARNDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    ARNRootView *rootView = [ARNRootViewFactory createRootView:@"pai://cardA/cardA?name=geeklyc&age=18"];
//    rootView.frame = CGRectMake(100, 100, 200, 200);
//    rootView.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:rootView];
//
//    ARNRootView *rootView1 = [ARNRootViewFactory createRootView:@"pai://cardB/cardB?name=geeklyc&age=18"];
//    rootView1.frame = CGRectMake(100, 400, 200, 200);
//    rootView1.backgroundColor = [UIColor redColor];
//    [self.view addSubview:rootView1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(javaScriptDidLoad:) name:RCTJavaScriptDidLoadNotification object:nil];
    
    self.businessLoaded = NO;
    NSURL *baseBundleURL = [[NSBundle mainBundle] URLForResource:@"common.ios" withExtension:@"bundle"];
    RCTBridge *bridge = [[RCTBridge alloc] initWithBundleURL:baseBundleURL moduleProvider:nil launchOptions:nil];
    self.bridge = bridge;
    
    
    
    
    
//    ARNRootView *rootView = [ARNRootViewFactory createRootView:@"pai://test/aPage?_debug=true&_devHost=192.168.95.58:8081&name=geeklyc&age=18"];
//    rootView.frame = CGRectMake(100, 100, 200, 200);
//    rootView.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:rootView];
    
//    ARNRootView *rootView1 = [ARNRootViewFactory createRootView:@"pai://test/bPage?_debug=true&_devHost=192.168.95.58:8081&name=geeklyc&age=18"];
//    rootView1.frame = CGRectMake(100, 400, 200, 200);
//    rootView1.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:rootView1];
    
    
    //
}

- (void)javaScriptDidLoad:(NSNotification *)noti {
    if (self.businessLoaded) {
        NSLog(@"【RNDemo】业务包加载完成");
        NSString *assetsPath = [self fetchAssetsPath:@"cardA"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"YXBundleLoad" object:nil userInfo:@{  @"path": assetsPath ? [NSString stringWithFormat:@"file://%@", assetsPath] : @"" }];
        
        RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:self.bridge moduleName:@"cardA" initialProperties:nil];
        rootView.frame = CGRectMake(100, 100, 200, 200);
        rootView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:rootView];
        return;
    }
    
    RCTBridge *bridge = (RCTBridge *)noti.object;
    NSLog(@"【RNDemo】主包加载完成 %@", bridge);
    
    // 解压包
    [self unzipFile:@"cardA"];
    NSString *bundlePath = [self fetchBundlePath:@"cardA"];
    
    // 加载代码
    NSError *error = nil;
    NSData *businessSourceData = [NSData dataWithContentsOfFile:bundlePath options:NSDataReadingMappedIfSafe error:&error];
    // 执行代码
    [self.bridge.batchedBridge executeSourceCode:businessSourceData sync:NO];
    self.businessLoaded = YES;
}

- (NSString *)fetchBundlePath:(NSString *)bundleName {
    return [[self createPackagePath] stringByAppendingFormat:@"/%@/%@.ios.bundle", bundleName, bundleName];
}

- (NSString *)fetchAssetsPath:(NSString *)bundleName {
    return [[self createPackagePath] stringByAppendingFormat:@"/%@/assets", bundleName];
}

- (BOOL)unzipFile:(NSString *)bundleName {
    // 压缩包存放路径
    NSString *zipPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@/ios", bundleName] ofType:@"zip"];
    // 解压缩后存放路径
    NSString *unzipPath = [self createBundlePath:bundleName];
    BOOL success  = [SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath];
    if (success) {
        NSLog(@"解压缩成功 %@", unzipPath);
    } else {
        NSLog(@"解压缩失败 %@", unzipPath);
    }
    return success;
}

- (NSString *)createBundlePath:(NSString *)bundleName {
    NSString *packagePath = [self createPackagePath];
    NSString *bundlePath = [packagePath stringByAppendingFormat:@"/%@", bundleName];
    
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:bundlePath isDirectory:&isDir] || !isDir) {
        // 目录不存在，创建
        [[NSFileManager defaultManager] createDirectoryAtPath:bundlePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return bundlePath;
}

- (NSString *)createBundleAssetPath {
    NSString *packagePath = [self createPackagePath];
    NSString *assetsPath = [packagePath stringByAppendingFormat:@"/%@", @"assets"];
    
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:assetsPath isDirectory:&isDir] || !isDir) {
        // 目录不存在，创建
        [[NSFileManager defaultManager] createDirectoryAtPath:assetsPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return assetsPath;
}

- (NSString *)createPackagePath {
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *packagePath = [cachePath stringByAppendingPathComponent:@"YxRnPackage"];
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:packagePath isDirectory:&isDir] || !isDir) {
        // 目录不存在，创建
        [[NSFileManager defaultManager] createDirectoryAtPath:packagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return packagePath;
}

@end
