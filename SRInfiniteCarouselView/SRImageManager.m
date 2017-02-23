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

@property (nonatomic, strong) NSMutableDictionary *redownloadManager;

@end

@implementation SRImageManager

+ (void)load {
    
    NSString *cacheDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
                                stringByAppendingPathComponent:NSStringFromClass([self class])];
    BOOL isDirectory = NO;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory isDirectory:&isDirectory];
    if (!isExists || !isDirectory) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSString *)cacheDirectoryPath {
    
    if (!_cacheDirectoryPath) {
        _cacheDirectoryPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
                               stringByAppendingPathComponent:NSStringFromClass([self class])];
    }
    return _cacheDirectoryPath;
}

- (NSMutableDictionary *)redownloadManager {
    
    if (!_redownloadManager) {
        _redownloadManager = [NSMutableDictionary dictionary];
    }
    return _redownloadManager;
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

- (UIImage *)imageFromCacheWithImageURLString:(NSString *)URLString {
    
    NSString *cacheImagePath = [self.cacheDirectoryPath stringByAppendingPathComponent:SRCacheFileName(URLString)];
    NSData *data = [NSData dataWithContentsOfFile:cacheImagePath];
    if (data.length > 0 ) {
        UIImage *image = [UIImage imageWithData:data];
        return image;
    } else {
        [[NSFileManager defaultManager] removeItemAtPath:cacheImagePath error:NULL];
    }
    return nil;
}

- (void)downloadWithImageURLString:(NSString *)URLString imageIndex:(NSInteger)index {
    
    UIImage *cacheImage = [self imageFromCacheWithImageURLString:URLString];
    if (cacheImage) {
        if (self.downloadImageSuccess) {
            self.downloadImageSuccess(cacheImage, index);
        }
        return;
    }
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:URLString]
                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         if (error) {
                                             [self redownloadWithImageURLString:URLString imageIndex:index error:error];
                                             return;
                                         }
                                         
                                         UIImage *image = [UIImage imageWithData:data];
                                         if (!image) {
                                             return;
                                         }
                                         
                                         if (self.downloadImageSuccess) {
                                             self.downloadImageSuccess(image, index);
                                         }
                                         
                                         BOOL flag = [data writeToFile:[self.cacheDirectoryPath stringByAppendingPathComponent:SRCacheFileName(URLString)] atomically:YES];
                                         if (!flag) {
                                             NSLog(@"Cache image data failed!");
                                         }
                                     });
                                 }] resume];
}

- (void)redownloadWithImageURLString:(NSString *)URLString imageIndex:(NSInteger)index error:(NSError *)error {
    
    NSNumber *redownloadNumber = self.redownloadManager[URLString];
    NSInteger redownloadTimes = redownloadNumber ? redownloadNumber.integerValue : 0;
    if (self.repeatCountWhenDownloadFailure > redownloadTimes ) {
        self.redownloadManager[URLString] = @(++redownloadTimes);
        [self downloadWithImageURLString:URLString imageIndex:index];
        return;
    }
    if (self.downloadImageFailure) {
        self.downloadImageFailure(error, URLString);
    }
}

- (void)clearCachedImages {

    NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.cacheDirectoryPath error:NULL];
    for (NSString *fileName in fileNames) {
        BOOL flag = [[NSFileManager defaultManager] removeItemAtPath:[self.cacheDirectoryPath stringByAppendingPathComponent:fileName] error:NULL];
        if (!flag) {
            NSLog(@"Delete image data failed!");
        }
    }
}

@end
