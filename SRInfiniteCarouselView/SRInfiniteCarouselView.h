//
//  SRImageCarouselView.h
//  SRInfiniteCarouselViewDemo
//
//  Created by 郭伟林 on 17/1/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRImageCarouselViewDelegate <NSObject>

@optional
- (void)imageCarouselViewDidTapImageAtIndex:(NSInteger)index;

@end

@interface SRInfiniteCarouselView : UIView

/**
 The interval between automatic page turning, default is 5.0s.
 */
@property (nonatomic, assign) NSTimeInterval timeInterval;

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

@property (nonatomic, weak) id<SRImageCarouselViewDelegate> delegate;

/**
 Create a SRInfiniteCarousel object with imageArrary, describeArray and delegate.
 
 @param imageArrary      The local images or the urls of images.
 @param describeArray    The image describes are in the same order as the images.
 @param placeholderImage The placeholder image when internet images have not download.
 @param delegate         delegate
 @return                 A SRInfiniteCarousel object
 */
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage delegate:(id<SRImageCarouselViewDelegate>)delegate;
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage;
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray;
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary;

- (instancetype)initWithImageArrary:(NSArray *)imageArrary;
- (instancetype)initWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray;
- (instancetype)initWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage;
- (instancetype)initWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage delegate:(id<SRImageCarouselViewDelegate>)delegate;

@end
