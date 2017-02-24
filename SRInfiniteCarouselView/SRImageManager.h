//
//  SRImageManager.h
//
//  Created by 郭伟林 on 17/1/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SRImageManager : NSObject

@property (nonatomic, assign) NSUInteger repeatCountWhenDownloadFailure;

@property (nonatomic, copy) void(^downloadImageSuccess)(UIImage *image, NSInteger imageIndex);

@property (nonatomic, copy) void(^downloadImageFailure)(NSError *error, NSString *imageURLString);

- (void)downloadWithImageURLString:(NSString *)URLString imageIndex:(NSInteger)index;

+ (void)clearCachedImages;

@end
