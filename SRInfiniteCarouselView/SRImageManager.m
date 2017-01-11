//
//  SRImageManager.m
//  SRInfiniteCarouselViewDemo
//
//  Created by 郭伟林 on 17/1/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRImageManager.h"

#define SRCacheFileName(URLString) [URLString lastPathComponent]

@interface SRImageManager ()

@property (nonatomic, copy) NSString *cacheDirectoryPath;

@property (nonatomic, strong) NSMutableDictionary *reDownloadImageDic;

@end

@implementation SRImageManager

- (NSString *)cacheDirectoryPath {
    
    if (!_cacheDirectoryPath) {
        _cacheDirectoryPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
                               stringByAppendingPathComponent:NSStringFromClass([self class])];
    }
    return _cacheDirectoryPath;
}

- (NSMutableDictionary *)reDownloadImageDic {
    
    if (!_reDownloadImageDic) {
        _reDownloadImageDic = [NSMutableDictionary dictionary];
    }
    return _reDownloadImageDic;
}

+ (instancetype)shareManager {
    
    static SRImageManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SRImageManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        _repeatCountWhenDownloadFailure = 2;
    }
    return self;
}

+ (void)load {
    
    NSString *cacheDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
                                stringByAppendingPathComponent:NSStringFromClass([self class])];
    BOOL isDirectory = NO;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory isDirectory:&isDirectory];
    if (!isExists || !isDirectory) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (BOOL)canLoadFromCacheWithImageURLString:(NSString *)URLString imageIndex:(NSInteger)index {
    
    NSString *cacheImagePath = [self.cacheDirectoryPath stringByAppendingPathComponent:SRCacheFileName(URLString)];
    NSData *data = [NSData dataWithContentsOfFile:cacheImagePath];
    if (data.length > 0 ) {
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            if (self.downloadImageSuccess) {
                self.downloadImageSuccess(image, URLString, index);
            }
            return YES;
        } else {
            [[NSFileManager defaultManager] removeItemAtPath:cacheImagePath error:NULL];
        }
    }
    return NO;
}

- (void)downloadWithImageURLString:(NSString *)URLString imageIndex:(NSInteger)index {
    
    BOOL flag = [self canLoadFromCacheWithImageURLString:URLString imageIndex:index];
    if (flag) {
        return;
    }
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:URLString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self reDownloadWithImageURLString:URLString imageIndex:index error:error];
                return ;
            }
            
            UIImage *image = [UIImage imageWithData:data];
            if (!image) {
                return;
            }
            
            BOOL flag = [data writeToFile:[self.cacheDirectoryPath stringByAppendingPathComponent:SRCacheFileName(URLString)] atomically:YES];
            if (!flag) {
                NSLog(@"cache image error.");
            }
            
            if (self.downloadImageSuccess) {
                self.downloadImageSuccess(image, URLString, index);
            }
        });
    }] resume];
}

- (void)reDownloadWithImageURLString:(NSString *)URLString imageIndex:(NSInteger)index error:(NSError *)error {
    
    NSNumber *number = [self.reDownloadImageDic objectForKey:URLString];
    NSInteger count = number ? number.integerValue : 0;
    if (self.repeatCountWhenDownloadFailure > count ) {
        [self.reDownloadImageDic setObject:@(++count) forKey:URLString];
        [self downloadWithImageURLString:URLString imageIndex:index];
    } else {
        if (self.downloadImageFailure) {
            self.downloadImageFailure(error, URLString);
        }
    }
}

- (void)clearCachedImages {

    NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.cacheDirectoryPath error:NULL];
    for (NSString *fileName in fileNames) {
        BOOL flag = [[NSFileManager defaultManager] removeItemAtPath:[self.cacheDirectoryPath stringByAppendingPathComponent:fileName] error:NULL];
        if (!flag) {
            NSLog(@"delete image error.");
        }
    }
}

@end
