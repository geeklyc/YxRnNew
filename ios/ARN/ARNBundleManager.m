//
//  ARNBundleManager.m
//  YxRnNew
//
//  Created by liyoucheng on 2022/7/7.
//  Copyright © 2022 geeklyc. All rights reserved.
//

#import "ARNBundleManager.h"

#import "SSZipArchive.h"

@interface ARNBundleManager ()

@property (nonatomic, strong) NSString *packagePath;

@end

@implementation ARNBundleManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ARNBundleManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ARNBundleManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.packagePath = [self createPackagePath];
    }
    return self;
}

// MARK: - public methods

- (void)start:(NSString *)bundleName {
    BOOL success = [self unzipFile:bundleName];
    if (!success) {
        NSLog(@"解压失败");
        return;
    }
    
    // 合并资源
//    [self mergeAssets:bundleName];
}

- (NSString *)fetchBundlePath:(NSString *)bundleName {
    return [self.packagePath stringByAppendingFormat:@"/%@/%@.ios.bundle", bundleName, bundleName];
}
//file:///Users/lyc/Library/Developer/CoreSimulator/Devices/CDB80ABB-97A3-4B52-82C6-4B6DC4E4068D/data/Containers/Bundle/Application/EC6DE863-93D5-4A16-9A53-0D46D2B40483/YxRnNew.app/
/////assets/src/pages/card-b/1.jpeg
///Users/lyc/Library/Developer/CoreSimulator/Devices/CDB80ABB-97A3-4B52-82C6-4B6DC4E4068D/data/Containers/Data/Application/9B90C6C1-C510-4F21-AD31-31FF360CC9EA/Library/Caches/YxRnPackage/
//cardB/assets/src/assets/1.jpeg
- (NSString *)fetchAssetsPath:(NSString *)bundleName {
//    return [self.packagePath stringByAppendingFormat:@"/assets/%@", bundleName];
    NSString *bundleDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [self.packagePath stringByAppendingFormat:@"/%@/assets", bundleName];
}

// MARK: - private methods

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

- (void)mergeAssets:(NSString *)bundleName {
    [self createBundleAssetPath];
    // 将业务包下 图片 移动到 assets 下
    NSString *srcPath = [self.packagePath stringByAppendingFormat:@"/%@/assets/src/assets", bundleName];
    NSString *dstPath = [self.packagePath stringByAppendingFormat:@"/assets/%@", bundleName];
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:dstPath error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:[self.packagePath stringByAppendingFormat:@"/%@/assets", bundleName] error:nil];
}

@end
