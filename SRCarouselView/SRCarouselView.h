//
//  SRCarouselView.h
//  SRCarouselView
//
//  Created by https://github.com/guowilling on 17/1/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRCarouselViewDelegate <NSObject>

- (void)carouselViewDidTapImageAtIndex:(NSInteger)index;

@end

@interface SRCarouselView : UIView

/**
 The time interval of auto paging, default is 5.0s.
 */
@property (nonatomic, assign) NSTimeInterval autoPagingInterval;

@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

@property (nonatomic, strong) UIImage *currentPageIndicatorImage;
@property (nonatomic, strong) UIImage *pageIndicatorImage;

/**
 Creates and returns a infinite carousel view with imageArrary, describeArray, placeholderImage and delegate.
 
 @param imageArrary      An array contains local images, or urls of images, or mixed of them.
 @param describeArray    An array contains image describes which in the same order as the images.
 @param placeholderImage The placeholder image when network image have not downloaded.
 @param delegate         The receiver’s delegate object.
 @return A newly infinite carousel view.
 */
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage delegate:(id<SRCarouselViewDelegate>)delegate;
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage;
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray;
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary;

@end

#pragma mark -

@interface SRCarouselImageManager : NSObject

@property (nonatomic, assign) NSUInteger repeatCountWhenDownloadFailed;

@property (nonatomic, copy) void(^downloadImageSuccess)(UIImage *image, NSInteger imageIndex);

@property (nonatomic, copy) void(^downloadImageFailure)(NSError *error, NSString *imageURLString);

- (void)downloadImageURLString:(NSString *)imageURLString imageIndex:(NSInteger)imageIndex;

+ (void)clearCachedImages;

@end
