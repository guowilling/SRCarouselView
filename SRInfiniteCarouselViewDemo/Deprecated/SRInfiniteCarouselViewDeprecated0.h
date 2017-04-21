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

@property (nonatomic, assign) NSTimeInterval timeInterval;

@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

@property (nonatomic, strong) UIImage *currentPageIndicatorImage;
@property (nonatomic, strong) UIImage *pageIndicatorImage;

@property (nonatomic, weak) id<SRInfiniteCarouselViewDelegate> delegate;

+ (instancetype)sr_infiniteCarouselViewWithImageArrary:(NSArray *)imageArrary;
+ (instancetype)sr_infiniteCarouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray;
+ (instancetype)sr_infiniteCarouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage;
+ (instancetype)sr_infiniteCarouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage delegate:(id<SRInfiniteCarouselViewDelegate>)delegate;

- (instancetype)initWithImageArrary:(NSArray *)imageArrary;
- (instancetype)initWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray;
- (instancetype)initWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage;
- (instancetype)initWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage delegate:(id<SRInfiniteCarouselViewDelegate>)delegate;

- (void)clearImagesCache;

@end
