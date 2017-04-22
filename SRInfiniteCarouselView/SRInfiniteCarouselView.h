//
//  SRInfiniteCarouselView.h
//
//  Created by 郭伟林 on 17/1/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRImageCarouselViewDelegate <NSObject>

- (void)imageCarouselViewDidTapImageAtIndex:(NSInteger)index;

@end

@interface SRInfiniteCarouselView : UIView

/**
 The interval of automatic paging, default is 5.0s.
 */
@property (nonatomic, assign) NSTimeInterval autoPagingInterval;

/**
 The tint color of current page indicator.
 */
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

/**
 The tint color of other page indicator.
 */
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

/**
 The image of current page indicator.
 */
@property (nonatomic, strong) UIImage *currentPageIndicatorImage;

/**
 The image of other page indicator.
 */
@property (nonatomic, strong) UIImage *pageIndicatorImage;

/**
 Creates and returns a SRInfiniteCarouselView object with imageArrary, describeArray, placeholderImage and delegate.
 
 @param imageArrary      The local images or the urls of images or mixed of them.
 @param describeArray    The describes which in the same order as the images.
 @param placeholderImage The placeholder image when internet images have not download.
 @param delegate         The delegate of this object.
 @return A SRInfiniteCarouselView object.
 */
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage delegate:(id<SRImageCarouselViewDelegate>)delegate;
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage;
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray;
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary;

@end
