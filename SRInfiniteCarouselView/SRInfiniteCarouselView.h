//
//  SRInfiniteCarouselView.h
//  SRInfiniteCarouselViewDemo
//
//  Created by 郭伟林 on 16/9/3.
//  Copyright © 2016年 SR. All rights reserved.
//

/**
 *  If you have any question, please issue or contact me.
 *  QQ: 396658379
 *  Email: guowilling@qq.com
 *
 *  If you like it, please star it, thanks a lot.
 *  Github: https://github.com/guowilling/SRInfiniteCarouselView
 *
 *  Have Fun.
 */

#import <UIKit/UIKit.h>

@class SRInfiniteCarouselView;

@protocol SRInfiniteCarouselViewDelegate <NSObject>

@optional

/**
 *  SRInfiniteCarouselView's delegate method.
 *
 *  @param infiniteCarouselView The current SRInfiniteCarouselView object.
 *  @param index                The index of clicked image.
 */
- (void)infiniteCarouselView:(SRInfiniteCarouselView *)infiniteCarouselView didClickImageAtIndex:(NSInteger)index;

@end

@interface SRInfiniteCarouselView : UIView

@property (nonatomic, weak) id<SRInfiniteCarouselViewDelegate> delegate;

/**
 Distance to bottom of pageControl, Default is 10.0f.
 */
@property (nonatomic, assign) CGFloat pageControlBottomDistance;

/** 
 Forbid manual scrolling, Default is NO, allow manual scrolling. 
 */
@property (nonatomic, assign) BOOL forbidScrolling;

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
                                    timeInterval:(NSInteger)timeInterval
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
                            timeInterval:(NSInteger)timeInterval
                   currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                          pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                                        delegate:(id<SRInfiniteCarouselViewDelegate>)delegate;

@end
