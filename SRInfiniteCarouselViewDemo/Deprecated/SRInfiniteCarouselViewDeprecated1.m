//
//  SRInfiniteCarouselView.m
//  SRInfiniteCarouselViewDemo
//
//  Created by 郭伟林 on 16/9/3.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRInfiniteCarouselViewDeprecated1.h"
#import "UIImageView+WebCache.h"

@interface SRInfiniteCarouselViewDeprecated1 () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView  *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, copy) NSArray  *imageNames;
@property (nonatomic, copy) NSArray  *imageURLs;
@property (nonatomic, copy) NSString *placeholderImageName;

@property (nonatomic, assign) NSTimeInterval  timeInterval;
@property (nonatomic, strong) NSTimer        *timer;

@property (nonatomic, assign) NSInteger imageCount;

@end

@implementation SRInfiniteCarouselViewDeprecated1

+ (instancetype)sr_infiniteCarouselViewWithFrame:(CGRect)frame
                                      imageNames:(NSArray *)imageNames
                                    timeInterval:(NSTimeInterval)timeInterval
                   currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                          pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                                        delegate:(id<SRInfiniteCarouselViewDelegate>)delegate
{
    return [[self alloc] initWithFrame:frame
                            imageNames:imageNames
                          timeInterval:timeInterval
         currentPageIndicatorTintColor:currentPageIndicatorTintColor
                pageIndicatorTintColor:pageIndicatorTintColor
                              delegate:delegate];
}

+ (instancetype)sr_infiniteCarouselViewWithFrame:(CGRect)frame
                                       imageURLs:(NSArray *)imageURLs
                            placeholderImageName:(NSString *)placeholderImageName
                                    timeInterval:(NSTimeInterval)timeInterval
                   currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                          pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                                        delegate:(id<SRInfiniteCarouselViewDelegate>)delegate
{
    return [[self alloc] initWithFrame:frame
                             imageURLs:imageURLs
                  placeholderImageName:placeholderImageName
                          timeInterval:timeInterval
         currentPageIndicatorTintColor:currentPageIndicatorTintColor
                pageIndicatorTintColor:pageIndicatorTintColor
                              delegate:delegate];
}

- (instancetype)initWithFrame:(CGRect)frame
                   imageNames:(NSArray *)imageNames
                 timeInterval:(NSInteger)timeInterval
currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
       pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                     delegate:(id<SRInfiniteCarouselViewDelegate>)delegate
{
    if (self = [super initWithFrame:frame]) {
        _delegate                      = delegate;
        _imageNames                    = imageNames;
        _imageCount                    = imageNames.count;
        _timeInterval                  = timeInterval;
        _currentPageIndicatorTintColor = currentPageIndicatorTintColor ?: [UIColor whiteColor];
        _pageIndicatorTintColor        = pageIndicatorTintColor ?: [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _pageControlBottomDistance     = 10.0f;
        [self setupWithLocalImage];
        [self startTimer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                    imageURLs:(NSArray *)imageURLs
         placeholderImageName:(NSString *)placeholderImageName
                 timeInterval:(NSInteger)timeInterval
currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
       pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                     delegate:(id<SRInfiniteCarouselViewDelegate>)delegate
{
    if (self = [super initWithFrame:frame]) {
        _delegate                      = delegate;
        _imageURLs                     = imageURLs;
        _imageCount                    = imageURLs.count;
        _placeholderImageName          = placeholderImageName;
        _timeInterval                  = timeInterval;
        _currentPageIndicatorTintColor = currentPageIndicatorTintColor ?: [UIColor whiteColor];
        _pageIndicatorTintColor        = pageIndicatorTintColor ?: [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _pageControlBottomDistance     = 10.0f;
        [self setupWithInternetImage];
        [self startTimer];
    }
    return self;
}

- (void)setupWithLocalImage {
    
    CGFloat scrollW = self.frame.size.width;
    CGFloat scrollH = self.frame.size.height;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollW, scrollH)];
    [self addSubview:({
        scrollView.delegate      = self;
        scrollView.scrollsToTop  = NO;
        scrollView.pagingEnabled = YES;
        scrollView.contentOffset = CGPointMake(scrollW, 0);
        scrollView.contentSize   = CGSizeMake((self.imageCount + 2) * scrollW, 0);
        scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView = scrollView;
    })];
    
    for (int i = 0; i < self.imageCount + 2; i++) {
        NSInteger tag = 0;
        if (i == 0) {
            tag = self.imageCount;
        } else if (i == self.imageCount + 1) {
            tag = 1;
        } else {
            tag = i;
        }
        NSString *currentImageName = self.imageNames[tag - 1];
        [scrollView addSubview:({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:currentImageName];
            imageView.tag = tag;
            imageView.clipsToBounds          = YES;
            imageView.userInteractionEnabled = YES;
            imageView.contentMode            = UIViewContentModeScaleAspectFill;
            imageView.frame                  = CGRectMake(scrollW * i, 0, scrollW, scrollH);
            UITapGestureRecognizer *tap      = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTaped:)];
            [imageView addGestureRecognizer:tap];
            imageView;
        })];
    }
    
    [self addSubview:({
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.center                        = CGPointMake(scrollW * 0.5, scrollH - _pageControlBottomDistance);
        pageControl.numberOfPages                 = self.imageCount;
        pageControl.userInteractionEnabled        = NO;
        pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
        pageControl.pageIndicatorTintColor        = self.pageIndicatorTintColor;
        [self addSubview:pageControl];
        _pageControl = pageControl;
    })];
}

- (void)setupWithInternetImage {
    
    CGFloat scrollW = self.frame.size.width;
    CGFloat scrollH = self.frame.size.height;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollW, scrollH)];
    [self addSubview:({
        scrollView.delegate      = self;
        scrollView.scrollsToTop  = NO;
        scrollView.pagingEnabled = YES;
        scrollView.contentOffset = CGPointMake(scrollW, 0);
        scrollView.contentSize   = CGSizeMake((self.imageCount + 2) * scrollW, 0);
        scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView = scrollView;
    })];
    
    for (int i = 0; i < self.imageCount + 2; i++) { // Create two more
        NSInteger tag = 0;
        if (i == 0) { //  When the currently displayed the first picture, the left is last picture
            tag = self.imageCount;
        } else if (i == self.imageCount + 1) { // When the currently displayed the last picture, the right is first picture
            tag = 1;
        } else {
            tag = i;
        }
        NSString *currentImageURLString = self.imageURLs[tag - 1];
        [scrollView addSubview:({
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:currentImageURLString]
                         placeholderImage:[UIImage imageNamed:self.placeholderImageName]];
            imageView.tag = tag;
            imageView.clipsToBounds          = YES;
            imageView.userInteractionEnabled = YES;
            imageView.contentMode            = UIViewContentModeScaleAspectFill;
            imageView.frame                  = CGRectMake(scrollW * i, 0, scrollW, scrollH);
            UITapGestureRecognizer *tap      = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTaped:)];
            [imageView addGestureRecognizer:tap];
             imageView;
        })];
    }
    
    [self addSubview:({
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.center = CGPointMake(scrollW * 0.5, scrollH - _pageControlBottomDistance);
        pageControl.numberOfPages                 = self.imageCount;
        pageControl.userInteractionEnabled        = NO;
        pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
        pageControl.pageIndicatorTintColor        = self.pageIndicatorTintColor;
        _pageControl = pageControl;
    })];
}

- (void)imageViewTaped:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(infiniteCarouselView:didClickImageAtIndex:)]) {
        [self.delegate infiniteCarouselView:self didClickImageAtIndex:tap.view.tag - 1];
    }
}

#pragma mark - Timer

- (void)startTimer {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval
                                                  target:self
                                                selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)nextImage {
    
    CGFloat scrollViewW = self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(scrollViewW + scrollViewW * (self.pageControl.currentPage + 1), 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat scrollViewW = scrollView.frame.size.width;
    NSInteger currentPage = scrollView.contentOffset.x / scrollViewW;
    if (currentPage == self.imageCount + 1) {
        self.pageControl.currentPage = 0;
        [scrollView setContentOffset:CGPointMake(scrollViewW, 0) animated:NO]; // Go start!
    } else if (currentPage == 0) {
        self.pageControl.currentPage = self.imageCount;
        [scrollView setContentOffset:CGPointMake(self.imageCount * scrollViewW, 0) animated:NO]; // Go end!
    } else {
        self.pageControl.currentPage = currentPage - 1;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self startTimer];
}

#pragma mark - Public method

- (void)setPageControlBottomDistance:(CGFloat)pageControlBottomDistance {
    
    _pageControlBottomDistance = pageControlBottomDistance;
    
    CGRect frame = self.pageControl.frame;
    frame.origin.y = self.frame.size.height - 10.0f - pageControlBottomDistance;
    self.pageControl.frame = frame;
}

- (void)setForbidScrolling:(BOOL)forbidScrolling {
    
    _forbidScrolling = forbidScrolling;
    
    if (forbidScrolling) {
        self.scrollView.scrollEnabled = NO;
    } else {
        self.scrollView.scrollEnabled = YES;
    }
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor ?: [UIColor whiteColor];
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    
    _pageIndicatorTintColor = pageIndicatorTintColor;
    
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor ?: [UIColor grayColor];
}

@end
