//
//  SRImageManager.m
//  SRInfiniteCarouselView
//
//  Created by 郭伟林 on 17/1/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRImageManager.h"

#define SRImagesDirectory      [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] \
                                 stringByAppendingPathComponent:NSStringFromClass([self class])]

#define SRImageName(URLString) [URLString lastPathComponent]

#define SRImagePath(URLString) [SRImagesDirectory stringByAppendingPathComponent:SRImageName(URLString)]

@interface SRImageManager ()

@property (nonatomic, strong) NSMutableDictionary *redownloadManager;

@end

@implementation SRImageManager

+ (void)load {
    
    NSString *imagesDirectory = SRImagesDirectory;
    BOOL isDirectory = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:imagesDirectory isDirectory:&isDirectory];
    if (!isExists || !isDirectory) {
        [fileManager createDirectoryAtPath:imagesDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSMutableDictionary *)redownloadManager {
    
    if (!_redownloadManager) {
        _redownloadManager = [NSMutableDictionary dictionary];
    }
    return _redownloadManager;
}

- (instancetype)init {
    
    if (self = [super init]) {
        _repeatCountWhenDownloadFailed = 2;
    }
    return self;
}

- (UIImage *)imageFromSandboxWithImageURLString:(NSString *)imageURLString {
    
    NSString *imagePath = SRImagePath(imageURLString);
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    if (data.length > 0 ) {
        return [UIImage imageWithData:data];
    } else {
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:NULL];
    }
    return nil;
}

- (void)downloadWithImageURLString:(NSString *)imageURLString imageIndex:(NSInteger)imageIndex {
    
    UIImage *image = [self imageFromSandboxWithImageURLString:imageURLString];
    if (image) {
        if (self.downloadImageSuccess) {
            self.downloadImageSuccess(image, imageIndex);
        }
        return;
    }
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:imageURLString]
                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         if (error) {
                                             [self redownloadWithImageURLString:imageURLString imageIndex:imageIndex error:error];
                                             return;
                                         }
                                         
                                         UIImage *image = [UIImage imageWithData:data];
                                         if (!image) {
                                             return;
                                         }
                                         
                                         if (self.downloadImageSuccess) {
                                             self.downloadImageSuccess(image, imageIndex);
                                         }
                                         
                                         if (![data writeToFile:SRImagePath(imageURLString) atomically:YES]) {
                                             NSLog(@"writeToFile Failed!");
                                         }
                                     });
                                 }] resume];
}

- (void)redownloadWithImageURLString:(NSString *)imageURLString imageIndex:(NSInteger)imageIndex error:(NSError *)error {
    
    NSNumber *redownloadNumber = self.redownloadManager[imageURLString];
    NSInteger redownloadTimes = redownloadNumber ? redownloadNumber.integerValue : 0;
    if (self.repeatCountWhenDownloadFailed > redownloadTimes ) {
        self.redownloadManager[imageURLString] = @(++redownloadTimes);
        [self downloadWithImageURLString:imageURLString imageIndex:imageIndex];
        return;
    }
    if (self.downloadImageFailure) {
        self.downloadImageFailure(error, imageURLString);
    }
}

+ (void)clearCachedImages {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileNames = [fileManager contentsOfDirectoryAtPath:SRImagesDirectory error:nil];
    for (NSString *fileName in fileNames) {
        if (![fileManager removeItemAtPath:[SRImagesDirectory stringByAppendingPathComponent:fileName] error:nil]) {
            NSLog(@"removeItemAtPath Failed!");
        }
    }
}

@end
