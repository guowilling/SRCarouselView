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

- (void)infiniteCarouselView:(SRInfiniteCarouselViewDeprecated1 *)infiniteCarouselView didClickImageAtIndex:(NSInteger)index;

@end

@interface SRInfiniteCarouselViewDeprecated1 : UIView

@property (nonatomic, weak) id<SRInfiniteCarouselViewDelegate> delegate;

@property (nonatomic, assign) BOOL forbidScrolling;

@property (nonatomic, assign) CGFloat pageControlBottomDistance;

@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

+ (instancetype)sr_infiniteCarouselViewWithFrame:(CGRect)frame
                                      imageNames:(NSArray *)imageNames
                                    timeInterval:(NSTimeInterval)timeInterval
                   currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                          pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                                        delegate:(id<SRInfiniteCarouselViewDelegate>)delegate;

+ (instancetype)sr_infiniteCarouselViewWithFrame:(CGRect)frame
                                       imageURLs:(NSArray *)imageURLs
                            placeholderImageName:(NSString *)placeholderImageName
                                    timeInterval:(NSTimeInterval)timeInterval
                   currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                          pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                                        delegate:(id<SRInfiniteCarouselViewDelegate>)delegate;

@end
