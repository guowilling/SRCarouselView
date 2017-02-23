//
//  SRInfiniteCarouselView.h
//  SRInfiniteCarouselViewDemo
//
//  Created by 郭伟林 on 16/12/21.
//  Copyright © 2016年 SR. All rights reserved.
//  使用 2 个 UIImageView 实现的无线轮播图.

#import <UIKit/UIKit.h>

@protocol SRInfiniteCarouselViewDelegate <NSObject>

@optional
- (void)infiniteCarouselViewDidTapImageAtIndex:(NSInteger)index;

@end

@interface SRInfiniteCarouselViewDeprecated0 : UIView

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

@property (nonatomic, weak) id<SRInfiniteCarouselViewDelegate> delegate;

+ (instancetype)sr_infiniteCarouselViewWithImageArrary:(NSArray *)imageArrary;
+ (instancetype)sr_infiniteCarouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray;
+ (instancetype)sr_infiniteCarouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage;

/**
 Create a SRInfiniteCarouselView object with imageArrary, describeArray and delegate.
 
 @param imageArrary      The local images or the urls of images.
 @param describeArray    The image describes are in the same order as the images.
 @param placeholderImage The placeholder image when internet images have not download.
 @param delegate         delegate
 @return                 A SRInfiniteCarouselView object
 */
+ (instancetype)sr_infiniteCarouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage delegate:(id<SRInfiniteCarouselViewDelegate>)delegate;

- (instancetype)initWithImageArrary:(NSArray *)imageArrary;
- (instancetype)initWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray;
- (instancetype)initWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage;
- (instancetype)initWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage delegate:(id<SRInfiniteCarouselViewDelegate>)delegate;

/**
 Clear the images cache in the sandbox.
 */
- (void)clearImagesCache;

@end
