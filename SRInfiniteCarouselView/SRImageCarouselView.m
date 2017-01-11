//
//  SRImageCarouselView.m
//  SRInfiniteCarouselViewDemo
//
//  Created by 郭伟林 on 17/1/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRImageCarouselView.h"
#import "SRImageManager.h"

static NSString * const cacheFileName = @"SRInfiniteCarouselView";

@interface SRImageCarouselView () <UIScrollViewDelegate>

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

@implementation SRImageCarouselView

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

+ (instancetype)sr_imageCarouselViewWithImageArrary:(NSArray *)imageArrary {
    
    return [self sr_imageCarouselViewWithImageArrary:imageArrary describeArray:nil];
}

+ (instancetype)sr_imageCarouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray {
    
    return [self sr_imageCarouselViewWithImageArrary:imageArrary describeArray:describeArray placeholderImage:nil];
}

+ (instancetype)sr_imageCarouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage {
    
    return [self sr_imageCarouselViewWithImageArrary:imageArrary describeArray:describeArray placeholderImage:placeholderImage delegate:nil];
}

+ (instancetype)sr_imageCarouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage delegate:(id<SRImageCarouselViewDelegate>)delegate {
    
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
    
    if (_images.count > 1) {
        _scrollView.contentSize   = CGSizeMake(self.width * 3, 0);
        _scrollView.contentOffset = CGPointMake(self.width, 0);
        _currentImageView.frame   = CGRectMake(self.width, 0, self.width, self.height);
    } else {
        _scrollView.contentSize   = CGSizeZero;
        _scrollView.contentOffset = CGPointMake(0, 0);
        _currentImageView.frame   = CGRectMake(0, 0, self.width, self.height);
    }
    
    if (!_describeArray || _describeArray.count == 0) {
        _pageControl.frame = CGRectMake(self.width * 0.5 - self.pageControl.numberOfPages * 15 * 0.5, self.height - 20, self.pageControl.numberOfPages * 15, 20);
    } else {
        _pageControl.frame = CGRectMake(self.width - self.pageControl.numberOfPages * 15, self.height - 20, self.pageControl.numberOfPages * 15, 20);
        _descLabel.frame   = CGRectMake(0, self.height - 20, self.width, 20);
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
    
    [_scrollView setContentOffset:CGPointMake(self.width * 2, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (offsetX == self.width) {
        return;
    }
    
    if (offsetX > self.width) {
        _nextImageView.frame = CGRectMake(CGRectGetMaxX(_currentImageView.frame), 0, self.width, self.height);
        _nextIndex = _currentIndex + 1;
        if (_nextIndex == _images.count) {
            _nextIndex = 0;
        }
    }
    
    if (offsetX < self.width) {
        _nextImageView.frame = CGRectMake(0, 0, self.width, self.height);
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
    
    if (_scrollView.contentOffset.x == self.width) {
        // If paging not finished do not update content.
        return;
    }
    
    _currentIndex = _nextIndex;
    
    _pageControl.currentPage = _currentIndex;
    
    self.descLabel.text = self.describeArray[self.currentIndex];
    
    _currentImageView.image = _nextImageView.image;
    _currentImageView.frame = CGRectMake(self.width, 0, self.width, self.height);
    
    [_scrollView setContentOffset:CGPointMake(self.width, 0) animated:NO];
}

#pragma mark - Other

+ (void)load {
    
    NSString *cacheDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
                                stringByAppendingPathComponent:cacheFileName];
    BOOL isDirectory = NO;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory isDirectory:&isDirectory];
    if (!isExists || !isDirectory) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (CGFloat)height {
    
    return _scrollView.frame.size.height;
}

- (CGFloat)width {
    
    return _scrollView.frame.size.width;
}

- (void)tapImageAction {
    
    if ([self.delegate respondsToSelector:@selector(imageCarouselViewDidTapImageAtIndex:)]) {
        [self.delegate imageCarouselViewDidTapImageAtIndex:self.currentIndex];
    }
}

#pragma mark - Public Methods

- (void)clearImagesCache {
    
    NSString *cacheDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
                                stringByAppendingString:cacheFileName];
    NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheDirectory error:NULL];
    for (NSString *fileName in fileNames) {
        [[NSFileManager defaultManager] removeItemAtPath:[cacheDirectory stringByAppendingPathComponent:fileName] error:NULL];
    }
}

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
