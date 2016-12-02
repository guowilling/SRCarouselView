//
//  SRInifiniteCarouselExtensionView.h
//  SRInfiniteCarouselViewDemo
//
//  Created by 郭伟林 on 16/12/02.
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

@class SRInifiniteCarouselExtensionView;

@protocol SRInifiniteCarouselExtensionViewDelegate <NSObject>

@optional
- (void)infiniteCarouselView:(SRInifiniteCarouselExtensionView *)infiniteCarouselView didClickImageAtIndex:(NSInteger)index;

@end

@interface SRInifiniteCarouselExtensionView : UIView

@property (weak, nonatomic) id<SRInifiniteCarouselExtensionViewDelegate> delegate;

@property (strong, nonatomic) IBInspectable UIColor *currentPageIndicatorTintColor;

@property (strong, nonatomic) IBInspectable UIColor *pageIndicatorTintColor;

+ (instancetype)sr_infiniteCarouselViewWithFrame:(CGRect)frame
                                      imageNames:(NSArray *)imageNames
                                    timeInterval:(NSInteger)timeInterval
                   currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                          pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                                        delegate:(id<SRInifiniteCarouselExtensionViewDelegate>)delegate;

+ (instancetype)sr_infiniteCarouselViewWithFrame:(CGRect)frame
                                       imageURLs:(NSArray *)imageURLs
                            placeholderImageName:(NSString *)placeholderImageName
                                    timeInterval:(NSInteger)timeInterval
                   currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                          pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                                        delegate:(id<SRInifiniteCarouselExtensionViewDelegate>)delegate;

@end
