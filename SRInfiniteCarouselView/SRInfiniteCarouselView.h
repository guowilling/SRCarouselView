//
//  SRInfiniteCarouselView.h
//  SRInfiniteCarouselViewDemo
//
//  Created by 郭伟林 on 16/12/21.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRInfiniteCarouselViewDelegate <NSObject>

@optional
- (void)infiniteCarouselViewDidTapImageAtIndex:(NSInteger)index;

@end

@interface SRInfiniteCarouselView : UIView

/**
 The time interval of auto Paging, Default is 5.0s.
 */
@property (nonatomic, assign) NSTimeInterval timeInterval;

/**
 Current page indicator tint color.
 */
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

/**
 Other page indicator tint color.
 */
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

/**
 Current page indicator image.
 */
@property (nonatomic, strong) UIImage *currentPageIndicatorImage;

/**
 Other page indicator image.
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
 @return                 a SRInfiniteCarouselView object
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
