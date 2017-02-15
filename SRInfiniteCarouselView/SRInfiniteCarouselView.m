//
//  SRImageCarouselView.m
//  SRInfiniteCarouselViewDemo
//
//  Created by 郭伟林 on 17/1/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRInfiniteCarouselView.h"
#import "SRImageManager.h"

@interface SRInfiniteCarouselView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *describeArray;
@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) NSMutableArray      *images;
@property (nonatomic, strong) NSMutableDictionary *imageDic;
@property (nonatomic, strong) NSMutableDictionary *operationDic;

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel       *descLabel;

@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UIImageView *nextImageView;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger nextIndex;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) SRImageManager *imageManager;

@end

@implementation SRInfiniteCarouselView

- (void)dealloc {
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Lazy Load

- (SRImageManager *)imageManager {
    
    if (!_imageManager) {
        __weak typeof(self) weakSelf = self;
        _imageManager = [SRImageManager shareManager];
        _imageManager.downloadImageSuccess = ^(UIImage *image, NSString *imageURLString, NSInteger imageIndex) {
            weakSelf.images[imageIndex] = image;
            if (weakSelf.currentIndex == imageIndex) {
                [weakSelf.currentImageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
            }
        };
    }
    return _imageManager;
}

- (UILabel *)descLabel {
    
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _descLabel.textColor = [UIColor whiteColor];
        _descLabel.font = [UIFont systemFontOfSize:14];
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.hidden = YES;
        [self addSubview:_descLabel];
    }
    return _descLabel;
}

#pragma mark - Init Methods

+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary {
    
    return [self sr_carouselViewWithImageArrary:imageArrary describeArray:nil];
}

+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray {
    
    return [self sr_carouselViewWithImageArrary:imageArrary describeArray:describeArray placeholderImage:nil];
}

+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage {
    
    return [self sr_carouselViewWithImageArrary:imageArrary describeArray:describeArray placeholderImage:placeholderImage delegate:nil];
}

+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage delegate:(id<SRImageCarouselViewDelegate>)delegate {
    
    return [[self alloc] initWithImageArrary:imageArrary describeArray:describeArray placeholderImage:placeholderImage delegate:delegate];
}

- (instancetype)initWithImageArrary:(NSArray *)imageArrary {
    
    return [self initWithImageArrary:imageArrary describeArray:nil];
}

- (instancetype)initWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray {
    
    return [self initWithImageArrary:imageArrary describeArray:describeArray placeholderImage:nil];
}

- (instancetype)initWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage {
    
    return [self initWithImageArrary:imageArrary describeArray:describeArray placeholderImage:placeholderImage delegate:nil];
}

- (instancetype)initWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage delegate:(id<SRImageCarouselViewDelegate>)delegate {
    
    if (self = [super init]) {
        _imageArray       = imageArrary;
        _describeArray    = describeArray;
        _delegate         = delegate;
        _placeholderImage = placeholderImage;
        
        _operationQueue = [[NSOperationQueue alloc] init];
        _images         = [NSMutableArray array];
        _imageDic       = [NSMutableDictionary dictionary];
        _operationDic   = [NSMutableDictionary dictionary];
        
        [self setupContent];
    }
    return self;
}

#pragma mark - Setup UI

- (void)setupContent {
    
    if (_imageArray.count == 0) {
        return;
    }
    
    _currentIndex = 0;
    
    [self addSubview:({
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        
        [_scrollView addSubview:({
            _currentImageView = [[UIImageView alloc] init];
            _currentImageView.contentMode = UIViewContentModeScaleAspectFill;
            _currentImageView.userInteractionEnabled = YES;
            [_currentImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction)]];
            _currentImageView;
        })];
        
        [_scrollView addSubview:({
            _nextImageView = [[UIImageView alloc] init];
            _nextImageView.contentMode = UIViewContentModeScaleAspectFill;
            _nextImageView;
        })];
        
        _scrollView;
    })];
    
    [self addSubview:({
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.userInteractionEnabled = NO;
        _pageControl.numberOfPages = _imageArray.count;
        _pageControl.currentPage = 0;
        _pageControl;
    })];
    
    [self setupImages];
    
    [self setupImageDescribes];
}

- (void)setupImages {
    
    for (int i = 0; i < _imageArray.count; i++) {
        if ([_imageArray[i] isKindOfClass:[UIImage class]]) {  // Local images.
            [_images addObject:_imageArray[i]];
        }
        if ([_imageArray[i] isKindOfClass:[NSString class]]) { // Internet images.
            if (_placeholderImage) {
                [_images addObject:_placeholderImage];
            } else {
                [_images addObject:[NSNull null]];
            }
            [self.imageManager downloadWithImageURLString:self.imageArray[i] imageIndex:i];
        }
    }
    
    if ([_images[0] isKindOfClass:[NSNull class]]) {
        _currentImageView.image = nil;
    } else {
        _currentImageView.image = _images[0];
    }
}

- (void)setupImageDescribes {
    
    if (_describeArray && _describeArray.count > 0) {
        if (_describeArray.count < _images.count) {
            NSMutableArray *arrayM = [NSMutableArray arrayWithArray:_describeArray];
            for (NSInteger i = _describeArray.count; i<_images.count; i++) {
                [arrayM addObject:@""];
            }
            _describeArray = arrayM;
        }
        self.descLabel.hidden = NO;
        self.descLabel.text = [_describeArray firstObject];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;
    _scrollView.contentInset = UIEdgeInsetsZero;
    
    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height;

    if (_images.count > 1) {
        _scrollView.contentSize   = CGSizeMake(width * 3, 0);
        _scrollView.contentOffset = CGPointMake(width, 0);
        _currentImageView.frame   = CGRectMake(width, 0, width, height);
    } else {
        _scrollView.contentSize   = CGSizeZero;
        _scrollView.contentOffset = CGPointMake(0, 0);
        _currentImageView.frame   = CGRectMake(0, 0, width, height);
    }
    
    if (!_describeArray || _describeArray.count == 0) {
        _pageControl.frame = CGRectMake(width * 0.5 - _pageControl.numberOfPages * 15 * 0.5, height - 20, _pageControl.numberOfPages * 15, 20);
    } else {
        _pageControl.frame = CGRectMake(width - _pageControl.numberOfPages * 15, height - 20, _pageControl.numberOfPages * 15, 20);
        _descLabel.frame   = CGRectMake(0, height - 20, width, 20);
        [self bringSubviewToFront:_pageControl];
    }
    
    if (_images.count > 1) {
        [self startTimer];
    }
}

#pragma mark - Timer

- (void)startTimer {
    
    if (_images.count <= 1) {
        return;
    }
    
    if (_timer) {
        [self stopTimer];
    }
    
    _timer = [NSTimer timerWithTimeInterval:_timeInterval == 0 ? 5.0 : _timeInterval
                                     target:self
                                   selector:@selector(nextPage)
                                   userInfo:nil
                                    repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    
    [_timer invalidate];
    _timer = nil;
}

- (void)nextPage {
    
    CGFloat width = _scrollView.frame.size.width;
    [_scrollView setContentOffset:CGPointMake(width * 2, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (offsetX == width) {
        return;
    }
    
    if (offsetX > width) {
        _nextImageView.frame = CGRectMake(CGRectGetMaxX(_currentImageView.frame), 0, width, height);
        _nextIndex = _currentIndex + 1;
        if (_nextIndex == _images.count) {
            _nextIndex = 0;
        }
    }
    
    if (offsetX < width) {
        _nextImageView.frame = CGRectMake(0, 0, width, height);
        _nextIndex = _currentIndex - 1;
        if (_nextIndex < 0) {
            _nextIndex = _images.count - 1;
        }
    }
    
    if ([_images[_nextIndex] isKindOfClass:[NSNull class]]) {
        _nextImageView.image = nil;
    } else {
        _nextImageView.image = self.images[_nextIndex];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    // Stop timer when dragging scrollview manually.
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    // Start timer when stop dragging scrollview manually.
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // Update content when paging finishes manually.
    [self updateContent];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    // Update content when paging finishes automatically.
    [self updateContent];
}

- (void)updateContent {
    
    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height;
    
    if (_scrollView.contentOffset.x == width) {
        // If paging not finished do not update content.
        return;
    }
    
    _currentIndex = _nextIndex;
    
    _pageControl.currentPage = _currentIndex;
    
    self.descLabel.text = self.describeArray[self.currentIndex];
    
    _currentImageView.image = _nextImageView.image;
    _currentImageView.frame = CGRectMake(width, 0, width, height);
    
    [_scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
}

#pragma mark - Actions

- (void)tapImageAction {
    
    if ([self.delegate respondsToSelector:@selector(imageCarouselViewDidTapImageAtIndex:)]) {
        [self.delegate imageCarouselViewDidTapImageAtIndex:self.currentIndex];
    }
}

#pragma mark - Public Methods

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    
    if (_currentPageIndicatorTintColor != currentPageIndicatorTintColor) {
        _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
        _pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    }
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    
    if (_pageIndicatorTintColor != pageIndicatorTintColor) {
        _pageIndicatorTintColor = pageIndicatorTintColor;
        _pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
    }
}

- (void)setCurrentPageIndicatorImage:(UIImage *)currentPageIndicatorImage {
    
    if (_currentPageIndicatorImage != currentPageIndicatorImage) {
        _currentPageIndicatorImage = currentPageIndicatorImage;
        [_pageControl setValue:currentPageIndicatorImage forKey:@"currentPageImage"];
    }
}

- (void)setPageIndicatorImage:(UIImage *)pageIndicatorImage {
    
    if (_pageIndicatorImage != pageIndicatorImage) {
        _pageIndicatorImage = pageIndicatorImage;
        [_pageControl setValue:pageIndicatorImage forKey:@"pageImage"];
    }
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    
    if (_timeInterval != timeInterval) {
        _timeInterval = timeInterval;
        [self startTimer];
    }
}

@end
