//
//  SRInfiniteCarouselView.h
//  SRInfiniteCarouselViewDemo
//
//  Created by 郭伟林 on 16/9/3.
//  Copyright © 2016年 SR. All rights reserved.
//  使用 n + 2 个 UIImageView 实现的无线轮播图.


#import <UIKit/UIKit.h>

@class SRInfiniteCarouselViewDeprecated1;

@protocol SRInfiniteCarouselViewDelegate <NSObject>

@optional

/**
 *  SRInfiniteCarouselView's delegate method.
 *
 *  @param infiniteCarouselView The current SRInfiniteCarouselView object.
 *  @param index                The index of clicked image.
 */
- (void)infiniteCarouselView:(SRInfiniteCarouselViewDeprecated1 *)infiniteCarouselView didClickImageAtIndex:(NSInteger)index;

@end

@interface SRInfiniteCarouselViewDeprecated1 : UIView

@property (nonatomic, weak) id<SRInfiniteCarouselViewDelegate> delegate;

/**
 Forbid manual scrolling, Default is NO, allowing manual scrolling.
 */
@property (nonatomic, assign) BOOL forbidScrolling;

/**
 Distance to bottom of pageControl, Default is 10.0f.
 */
@property (nonatomic, assign) CGFloat pageControlBottomDistance;

/** 
 Current page indicator tint color, Default is [UIColor whiteColor]. 
 */
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

/** 
 Other page indicator tint color, Default is [UIColor grayColor]. 
 */
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

/**
 Initialize with local images.
 
 @param frame                         The frame of bannerView.
 @param imageNames                    The names of local images.
 @param timeInterval                  The time interval of auto Paging.
 @param currentPageIndicatorTintColor The indicator tint color of current page.
 @param pageIndicatorTintColor        The indicator tint color of other page.
 @param delegate                      The delegate of this object.

 @return A SRInfiniteCarouselView object
 */
+ (instancetype)sr_infiniteCarouselViewWithFrame:(CGRect)frame
                                      imageNames:(NSArray *)imageNames
                                    timeInterval:(NSTimeInterval)timeInterval
                   currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                          pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                                        delegate:(id<SRInfiniteCarouselViewDelegate>)delegate;

/**
 Initialize with internet images.
 
 @param frame                         The frame of bannerView.
 @param imageURLs                     The URLs of internet images.
 @param placeholderImageName          The name of placeholder image.
 @param timeInterval                  The time interval of auto Paging.
 @param currentPageIndicatorTintColor The indicator tint color of current page.
 @param pageIndicatorTintColor        The indicator tint color of other page.
 @param delegate                      The delegate of this object.
 
 @return A SRInfiniteCarouselView object
 */
+ (instancetype)sr_infiniteCarouselViewWithFrame:(CGRect)frame
                                       imageURLs:(NSArray *)imageURLs
                            placeholderImageName:(NSString *)placeholderImageName
                                    timeInterval:(NSTimeInterval)timeInterval
                   currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                          pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                                        delegate:(id<SRInfiniteCarouselViewDelegate>)delegate;

@end
