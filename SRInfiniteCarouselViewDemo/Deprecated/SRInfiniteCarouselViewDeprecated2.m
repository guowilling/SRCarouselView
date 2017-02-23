//
//  SRInifiniteCarouselExtensionView.m
//  SRInfiniteCarouselViewDemo
//
//  Created by 郭伟林 on 16/12/02.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRInfiniteCarouselViewDeprecated2.h"

@interface SRInfiniteCarouselViewDeprecated2 () <UIScrollViewDelegate>

@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UIScrollView  *scrollView;

@property (nonatomic, copy) NSArray  *images;
@property (nonatomic, copy) NSArray  *imageURLStrings;
@property (nonatomic, copy) NSString *placeholderImageName;

@property (nonatomic, weak) UIImageView *leftImageView;
@property (nonatomic, weak) UIImageView *currentImageView;
@property (nonatomic, weak) UIImageView *rightImageView;

@property (nonatomic, assign) NSTimeInterval  timeInterval;
@property (nonatomic, strong) NSTimer        *timer;

@property (nonatomic, assign) NSInteger imageCount;

@end

@implementation SRInfiniteCarouselViewDeprecated2

+ (instancetype)sr_infiniteCarouselViewWithFrame:(CGRect)frame
                                      imageNames:(NSArray *)imageNames
                                    timeInterval:(NSTimeInterval)timeInterval
                   currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                          pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                                        delegate:(id<SRInifiniteCarouselExtensionViewDelegate>)delegate
{
    return [[self alloc] initWithFrame:frame
                            imageNames:imageNames
                          timeInterval:timeInterval
         currentPageIndicatorTintColor:currentPageIndicatorTintColor
                pageIndicatorTintColor:pageIndicatorTintColor
                              delegate:delegate];
}

- (instancetype)initWithFrame:(CGRect)frame
                   imageNames:(NSArray *)imageNames
                 timeInterval:(NSTimeInterval)timeInterval
currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
       pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                     delegate:(id<SRInifiniteCarouselExtensionViewDelegate>)delegate
{
    if (self = [super initWithFrame:frame]) {
        _delegate                      = delegate;
        _images                        = imageNames;
        _imageCount                    = imageNames.count;
        _timeInterval                  = timeInterval;
        _currentPageIndicatorTintColor = currentPageIndicatorTintColor ?: [UIColor whiteColor];
        _pageIndicatorTintColor        = pageIndicatorTintColor ?: [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [self setupBasicSubviews];
        [self setupWithImages];
    }
    return self;
}

+ (instancetype)sr_infiniteCarouselViewWithFrame:(CGRect)frame
                                       imageURLs:(NSArray *)imageURLs
                            placeholderImageName:(NSString *)placeholderImageName
                                    timeInterval:(NSTimeInterval)timeInterval
                   currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                          pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                                        delegate:(id<SRInifiniteCarouselExtensionViewDelegate>)delegate
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
                    imageURLs:(NSArray *)imageURLs
         placeholderImageName:(NSString *)placeholderImageName
                 timeInterval:(NSTimeInterval)timeInterval
currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
       pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
                     delegate:(id<SRInifiniteCarouselExtensionViewDelegate>)delegate
{
    if (self = [super initWithFrame:frame]) {
        _delegate                      = delegate;
        _imageURLStrings               = imageURLs;
        _imageCount                    = imageURLs.count;
        _placeholderImageName          = placeholderImageName;
        _timeInterval                  = timeInterval;
        _currentPageIndicatorTintColor = currentPageIndicatorTintColor ?: [UIColor whiteColor];
        _pageIndicatorTintColor        = pageIndicatorTintColor ?: [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [self setupBasicSubviews];
        [self setupDownloadInternetImage];
    }
    return self;
}

- (void)setupBasicSubviews {
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.bounds;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = YES;
    scrollView.scrollEnabled = NO;
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    CGFloat imageViewW = self.scrollView.bounds.size.width;
    self.scrollView.contentSize = CGSizeMake(imageViewW * 3, 0);
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.hidesForSinglePage = YES;
    self.pageControl = pageControl;
    [self addSubview:pageControl];
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollView addSubview:leftImageView];
    self.leftImageView = leftImageView;
    
    UIImageView *currentImageView = [[UIImageView alloc] init];
    currentImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollView addSubview:currentImageView];
    self.currentImageView = currentImageView;
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollView addSubview:rightImageView];
    self.rightImageView = rightImageView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    self.currentImageView.userInteractionEnabled = YES;
    [self.currentImageView addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tapGesture {
    
    if ([self.delegate respondsToSelector:@selector(infiniteCarouselView:didClickImageAtIndex:)]) {
        [self.delegate infiniteCarouselView:self didClickImageAtIndex:self.currentImageView.tag];
    }
}

- (void)setupWithImages {
    
    self.currentImageView.image = self.images[0];
    self.currentImageView.tag   = 0;
    
    if (self.images.count > 1) {
        self.leftImageView.image = self.images[self.images.count - 1];
        self.leftImageView.tag   = self.images.count - 1;
        
        self.rightImageView.image = self.images[1];
        self.rightImageView.tag   = 1;
    }
    
    self.pageControl.numberOfPages = self.images.count;
    self.pageControl.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height - 10);
    
    CGFloat imageViewW = self.scrollView.bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake(imageViewW, 0)];
    
    self.scrollView.scrollEnabled = (self.images.count > 1);
    
    [self startTimer];
}

- (void)setupDownloadInternetImage {
    
    NSMutableArray *imagesM = [NSMutableArray arrayWithCapacity:_imageURLStrings.count];
    
    // Download first image.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_imageURLStrings firstObject]]]];
        if (image) {
            [imagesM addObject:image];
        }
        
        // Show first image.
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.currentImageView.image = image;
            CGFloat imageViewW = self.scrollView.bounds.size.width;
            [self.scrollView setContentOffset:CGPointMake(imageViewW, 0)];
            
            self.pageControl.numberOfPages = _imageURLStrings.count;
            self.pageControl.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height - 10);
        });
        
        // Download other image.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (NSInteger i = 1; i < _imageURLStrings.count; i++) {
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageURLStrings[i]]]];
                if (image) {
                    [imagesM addObject:image];
                }
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.images = imagesM;
                [self setupWithImages];
            });
        });
    });
}

- (void)startTimer {
    
    if (self.images.count <= 1) {
        return;
    }
    
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer {
    
    if (_timer) {
        [_timer invalidate];
         _timer = nil;
    }
}

- (void)nextPage {
    
    if (self.scrollView.contentOffset.x != 0) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width * 2, 0) animated:YES];
    }
}

- (void)updateContent {
    
    if (self.images.count <= 1) {
        return;
    }
    CGFloat scrollViewW = self.scrollView.bounds.size.width;
    
    if (self.scrollView.contentOffset.x > scrollViewW) {
        self.leftImageView.tag    = self.currentImageView.tag;
        self.currentImageView.tag = self.rightImageView.tag;
        self.rightImageView.tag   = (self.rightImageView.tag + 1) % self.images.count;
    } else if (self.scrollView.contentOffset.x < scrollViewW) {
        self.rightImageView.tag   = self.currentImageView.tag;
        self.currentImageView.tag = self.leftImageView.tag;
        self.leftImageView.tag    = (self.leftImageView.tag - 1 + self.images.count) % self.images.count;
    }
    
    self.leftImageView.image    = self.images[self.leftImageView.tag];
    self.currentImageView.image = self.images[self.currentImageView.tag];
    self.rightImageView.image   = self.images[self.rightImageView.tag];
    
    [self.scrollView setContentOffset:CGPointMake(scrollViewW, 0) animated:NO];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.images.count <= 1) return;
    
    if (self.scrollView.contentOffset.x > self.scrollView.bounds.size.width * 1.5) {
        self.pageControl.currentPage = self.rightImageView.tag;
    } else if (self.scrollView.contentOffset.x < self.scrollView.bounds.size.width * 0.5) {
        self.pageControl.currentPage = self.leftImageView.tag;
    } else {
        self.pageControl.currentPage = self.currentImageView.tag;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self updateContent];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self updateContent];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self startTimer];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    
    CGFloat imageViewW = self.scrollView.bounds.size.width;
    CGFloat imageViewH = self.scrollView.bounds.size.height;
    
    self.leftImageView.frame    = CGRectMake(0, 0, imageViewW, imageViewH);
    self.currentImageView.frame = CGRectMake(imageViewW, 0, imageViewW, imageViewH);
    self.rightImageView.frame   = CGRectMake(imageViewW * 2, 0, imageViewW, imageViewH);
    
    self.scrollView.contentSize = CGSizeMake(imageViewW * 3, 0);
    
    [self updateContent];
}

@end
