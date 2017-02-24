//
//  SRInfiniteCarouselView.m
//
//  Created by 郭伟林 on 17/1/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRInfiniteCarouselView.h"
#import "SRImageManager.h"

@interface SRInfiniteCarouselView () <UIScrollViewDelegate>

@property (nonatomic, strong) SRImageManager *imageManager;
@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *describeArray;
@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIImageView   *currentImageView;
@property (nonatomic, strong) UIImageView   *nextImageView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel       *descLabel;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger nextIndex;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SRInfiniteCarouselView

#pragma mark - Overriding

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
        _imageManager = [[SRImageManager alloc] init];
        _imageManager.downloadImageSuccess = ^(UIImage *image, NSInteger imageIndex) {
            weakSelf.images[imageIndex] = image;
            if (weakSelf.currentIndex == imageIndex) {
                weakSelf.currentImageView.image = image;
            }
        };
        _imageManager.downloadImageFailure = ^(NSError *error, NSString *imageURLString) {
            NSLog(@"Image: %@ download error: %@", imageURLString, error);
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
        
        _images       = [NSMutableArray array];
        _currentIndex = 0;
        _nextIndex    = 0;
        
        [self setupSubViews];
        [self startTimer];
    }
    return self;
}

#pragma mark - Setup UI

- (void)setupSubViews {
    
    if (_imageArray.count == 0) {
        return;
    }
    
    [self setupScrollView];
    [self setupPageControl];
    
    [self setupImages];
    [self setupImageDescribes];
}

- (void)setupScrollView {
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _currentImageView = [[UIImageView alloc] init];
    _currentImageView.contentMode = UIViewContentModeScaleAspectFill;
    _currentImageView.userInteractionEnabled = YES;
    [_currentImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCurrentImageView)]];
    [_scrollView addSubview:_currentImageView];
    
    _nextImageView = [[UIImageView alloc] init];
    _nextImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_nextImageView];
}

- (void)setupPageControl {
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.numberOfPages = _imageArray.count;
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];
}

- (void)setupImages {
    
    for (int i = 0; i < _imageArray.count; i++) {
        if ([_imageArray[i] isKindOfClass:[UIImage class]]) {  // Local images.
            [self.images addObject:_imageArray[i]];
        }
        if ([_imageArray[i] isKindOfClass:[NSString class]]) { // Internet images.
            if (_placeholderImage) { // Hold placeholder image if setted or use NSNull object replace if not.
                [self.images addObject:_placeholderImage];
            } else {
                [self.images addObject:[NSNull null]];
            }
            [self.imageManager downloadWithImageURLString:self.imageArray[i] imageIndex:i]; // Use SRImageManager to download image.
        }
    }
    
    // Show first image or placeholder image if exist.
    if ([self.images[0] isKindOfClass:[NSNull class]]) {
        _currentImageView.image = nil;
    } else {
        _currentImageView.image = self.images[0];
    }
}

- (void)setupImageDescribes {
    
    if (_describeArray && _describeArray.count > 0) {
        if (_describeArray.count < self.images.count) {
            NSMutableArray *arrayM = [NSMutableArray arrayWithArray:_describeArray];
            for (NSInteger i = _describeArray.count; i< self.images.count; i++) {
                [arrayM addObject:@""];
            }
            _describeArray = arrayM;
        }
        self.descLabel.hidden = NO;
        self.descLabel.text = _describeArray[0];
        [self bringSubviewToFront:_pageControl];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _scrollView.frame = self.bounds;
    _scrollView.contentInset = UIEdgeInsetsZero;
    
    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height;

    if (self.images.count > 1) {
        _scrollView.contentSize   = CGSizeMake(width * 3, 0);
        _scrollView.contentOffset = CGPointMake(width, 0);
        _currentImageView.frame   = CGRectMake(width, 0, width, height);
    } else {
        _scrollView.contentSize   = CGSizeZero;
        _scrollView.contentOffset = CGPointMake(0, 0);
        _currentImageView.frame   = CGRectMake(0, 0, width, height);
    }
    
    CGFloat pageControlDotWidth = 15;
    CGFloat pageControlHeight = 20;
    CGFloat descLabelHeight = pageControlHeight;
    if (!_describeArray || _describeArray.count == 0) {
        _pageControl.frame = CGRectMake(width * 0.5 - _pageControl.numberOfPages * pageControlDotWidth * 0.5, height - pageControlHeight,
                                        _pageControl.numberOfPages * pageControlDotWidth, pageControlHeight);
    } else {
        _pageControl.frame = CGRectMake(width - _pageControl.numberOfPages * pageControlDotWidth, height - pageControlHeight,
                                        _pageControl.numberOfPages * pageControlDotWidth, pageControlHeight);
        _descLabel.frame = CGRectMake(0, height - descLabelHeight, width, descLabelHeight);
    }
}

#pragma mark - Timer

- (void)startTimer {
    
    if (self.images.count <= 1) {
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
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Actions

- (void)nextPage {
    
    CGFloat width = _scrollView.frame.size.width;
    [_scrollView setContentOffset:CGPointMake(width * 2, 0) animated:YES];
}

- (void)didTapCurrentImageView {
    
    if ([self.delegate respondsToSelector:@selector(imageCarouselViewDidTapImageAtIndex:)]) {
        [self.delegate imageCarouselViewDidTapImageAtIndex:self.currentIndex];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat width = _scrollView.frame.size.width;
    if (offsetX == width) {
        return;
    }
    
    CGFloat height = _scrollView.frame.size.height;
    
    if (offsetX > width) {
        _nextImageView.frame = CGRectMake(CGRectGetMaxX(_currentImageView.frame), 0, width, height);
        _nextIndex = _currentIndex + 1;
        if (_nextIndex == self.images.count) {
            _nextIndex = 0;
        }
    }
    
    if (offsetX < width) {
        _nextImageView.frame = CGRectMake(0, 0, width, height);
        _nextIndex = _currentIndex - 1;
        if (_nextIndex < 0) {
            _nextIndex = self.images.count - 1;
        }
    }
    
    if ([self.images[_nextIndex] isKindOfClass:[NSNull class]]) {
        _nextImageView.image = nil;
    } else {
        _nextImageView.image = self.images[_nextIndex];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self stopTimer]; // Stop timer when dragging scrollview manually.
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self startTimer]; // Start timer when stop dragging scrollview manually.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self updateContent]; // Update content when paging finishes manually.
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self updateContent]; // Update content when paging finishes automatically.
}

- (void)updateContent {
    
    CGFloat width = _scrollView.frame.size.width;
    if (_scrollView.contentOffset.x == width) {
        return; // If paging not finished do not update content.
    }
    
    CGFloat height = _scrollView.frame.size.height;
    
    _currentIndex = _nextIndex;
    
    _pageControl.currentPage = _currentIndex;
    
    self.descLabel.text = self.describeArray[self.currentIndex];
    
    _currentImageView.image = _nextImageView.image;
    _currentImageView.frame = CGRectMake(width, 0, width, height);
    
    [_scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
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
