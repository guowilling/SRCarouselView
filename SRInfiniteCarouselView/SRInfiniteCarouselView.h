//
//  SRInfiniteCarouselView.h
//
//  Created by 郭伟林 on 17/1/10.
//  Copyright © 2017年 SR. All rights reserved.
//

/**
 *  If you have any question, submit an issue or contact me.
 *  QQ: 1990991510
 *  Email: guowilling@qq.com
 *
 *  If this repo helped you, please give it a star.
 *  Github: https://github.com/guowilling/SRInfiniteCarouselView
 *
 *  Have Fun.
 */

#import <UIKit/UIKit.h>

@protocol SRImageCarouselViewDelegate <NSObject>

@optional
- (void)imageCarouselViewDidTapImageAtIndex:(NSInteger)index;

@end

@interface SRInfiniteCarouselView : UIView

/**
 Interval between automatic page turning, default is 5.0s.
 */
@property (nonatomic, assign) NSTimeInterval timeInterval;

/**
 Tint color of current page indicator.
 */
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

/**
 Tint color of other page indicator.
 */
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

/**
 Image of current page indicator.
 */
@property (nonatomic, strong) UIImage *currentPageIndicatorImage;

/**
 Image of other page indicator.
 */
@property (nonatomic, strong) UIImage *pageIndicatorImage;

@property (nonatomic, weak) id<SRImageCarouselViewDelegate> delegate;

/**
 Create a SRInfiniteCarouselView object with imageArrary, describeArray, placeholderImage and delegate.
 
 @param imageArrary      Local images or the urls of images.
 @param describeArray    Image describes are in the same order as the images.
 @param placeholderImage Placeholder image when internet images have not download.
 @param delegate         Delegate
 @return                 A SRInfiniteCarouselView object
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
