//
//  SRInifiniteCarouselExtensionView.h
//  SRInfiniteCarouselViewDemo
//
//  Created by 郭伟林 on 16/12/02.
//  Copyright © 2016年 SR. All rights reserved.
//  使用 3 个 UIImageView 实现的无线轮播图.

#import <UIKit/UIKit.h>

@class SRInfiniteCarouselViewDeprecated2;

@protocol SRInifiniteCarouselExtensionViewDelegate <NSObject>

@optional

- (void)infiniteCarouselView:(SRInfiniteCarouselViewDeprecated2 *)infiniteCarouselView didClickImageAtIndex:(NSInteger)index;

@end

@interface SRInfiniteCarouselViewDeprecated2 : UIView

@property (weak, nonatomic) id<SRInifiniteCarouselExtensionViewDelegate> delegate;

@property (strong, nonatomic) IBInspectable UIColor *currentPageIndicatorTintColor;

@property (strong, nonatomic) IBInspectable UIColor *pageIndicatorTintColor;

+ (instancetype)sr_infiniteCarouselViewWithFrame:(CGRect)frame
                                      imageNames:(NSArray *)imageNames
                                    timeInterval:(NSTimeInterval)timeInterval
                   currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                          pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                                        delegate:(id<SRInifiniteCarouselExtensionViewDelegate>)delegate;

+ (instancetype)sr_infiniteCarouselViewWithFrame:(CGRect)frame
                                       imageURLs:(NSArray *)imageURLs
                            placeholderImageName:(NSString *)placeholderImageName
                                    timeInterval:(NSTimeInterval)timeInterval
                   currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                          pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                                        delegate:(id<SRInifiniteCarouselExtensionViewDelegate>)delegate;

@end
