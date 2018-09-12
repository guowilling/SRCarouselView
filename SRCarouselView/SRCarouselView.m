//
//  SRCarouselView.m
//  SRCarouselView
//
//  Created by https://github.com/guowilling on 17/1/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "SRCarouselView.h"

@interface SRCarouselImageManager : NSObject

@property (nonatomic, assign) NSUInteger repeatCountWhenDownloadFailed;

@property (nonatomic, copy) void(^downloadImageSuccess)(UIImage *image, NSInteger imageIndex);

@property (nonatomic, copy) void(^downloadImageFailure)(NSError *error, NSString *imageURLString);

- (void)downloadImage:(NSString *)imageURLString index:(NSInteger)imageIndex;

+ (void)clearCachedImages;

@end

#pragma mark -

@interface SRCarouselView () <UIScrollViewDelegate>

@property (nonatomic, weak) id<SRCarouselViewDelegate> delegate;
@property (nonatomic, copy) SRDidTapCarouselViewAtIndexBlock block;

@property (nonatomic, strong) SRCarouselImageManager *imageManager;
@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *describeArray;
@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIImageView   *currentImageView;
@property (nonatomic, strong) UIImageView   *nextImageView;
@property (nonatomic, strong) UIView        *bottomContainer;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel       *descLabel;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger nextIndex;

@property (nonatomic, strong) NSTimer *autoPagingTimer;

@end

@implementation SRCarouselView

#pragma mark - Overriding

- (void)dealloc {
    [self stopAutoPagingTimer];
}

#pragma mark - Lazy Load

- (SRCarouselImageManager *)imageManager {
    if (!_imageManager) {
        __weak typeof(self) weakSelf = self;
        _imageManager = [[SRCarouselImageManager alloc] init];
        _imageManager.downloadImageSuccess = ^(UIImage *image, NSInteger imageIndex) {
            weakSelf.images[imageIndex] = image;
            if (weakSelf.currentIndex == imageIndex) {
                weakSelf.currentImageView.image = image;
            }
        };
        _imageManager.downloadImageFailure = ^(NSError *error, NSString *imageURLString) {
            NSLog(@"downloadImageFailure error: %@", error);
        };
    }
    return _imageManager;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = [UIColor whiteColor];
        _descLabel.font = [UIFont systemFontOfSize:15];
        _descLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_descLabel];
    }
    return _descLabel;
}

#pragma mark - Init Methods

+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary {
    return [self sr_carouselViewWithImageArrary:imageArrary describeArray:nil placeholderImage:nil delegate:nil];
}

+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray {
    return [self sr_carouselViewWithImageArrary:imageArrary describeArray:describeArray placeholderImage:nil delegate:nil];
}

+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage {
    return [self sr_carouselViewWithImageArrary:imageArrary describeArray:describeArray placeholderImage:placeholderImage delegate:nil];
}

+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary
                                 describeArray:(NSArray *)describeArray
                              placeholderImage:(UIImage *)placeholderImage
                                      delegate:(id<SRCarouselViewDelegate>)delegate
{
    return [[self alloc] initWithImageArrary:imageArrary
                               describeArray:describeArray
                            placeholderImage:placeholderImage
                                    delegate:delegate];
}

- (instancetype)initWithImageArrary:(NSArray *)imageArrary
                      describeArray:(NSArray *)describeArray
                   placeholderImage:(UIImage *)placeholderImage
                           delegate:(id<SRCarouselViewDelegate>)delegate
{
    if (self = [super init]) {
        _imageArray       = imageArrary;
        _describeArray    = describeArray;
        _placeholderImage = placeholderImage;
        
        _delegate = delegate;
        
        _images = [NSMutableArray array];
        
        _currentIndex = 0;
        _nextIndex    = 0;
        
        [self setup];
        [self startAutoPagingTimer];
    }
    return self;
}

+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary
                                 describeArray:(NSArray *)describeArray
                              placeholderImage:(UIImage *)placeholderImage
                                         block:(SRDidTapCarouselViewAtIndexBlock)block
{
    return [[self alloc] initWithImageArrary:imageArrary
                               describeArray:describeArray
                            placeholderImage:placeholderImage
                                       block:block];
}

- (instancetype)initWithImageArrary:(NSArray *)imageArrary
                      describeArray:(NSArray *)describeArray
                   placeholderImage:(UIImage *)placeholderImage
                              block:(SRDidTapCarouselViewAtIndexBlock)block
{
    if (self = [super init]) {
        _imageArray       = imageArrary;
        _describeArray    = describeArray;
        _placeholderImage = placeholderImage;
        
        _block = block;
        
        _images = [NSMutableArray array];
        
        _currentIndex = 0;
        _nextIndex    = 0;
        
        [self setup];
        [self startAutoPagingTimer];
    }
    return self;
}

#pragma mark - Setup UI

- (void)setup {
    if (_imageArray.count == 0) {
        return;
    }
    [self setupSubviews];
    [self setupImages];
    [self setupImageDescribes];
}

- (void)setupSubviews {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.numberOfPages = _imageArray.count;
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];
    
    _currentImageView = [[UIImageView alloc] init];
    _currentImageView.contentMode = UIViewContentModeScaleAspectFill;
    _currentImageView.layer.masksToBounds = YES;
    [_scrollView addSubview:_currentImageView];
    
    _nextImageView = [[UIImageView alloc] init];
    _nextImageView.contentMode = UIViewContentModeScaleAspectFill;
    _nextImageView.layer.masksToBounds = YES;
    [_scrollView addSubview:_nextImageView];
    
    _currentImageView.userInteractionEnabled = YES;
    [_currentImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCurrentImageView)]];
}

- (void)setupImages {
    for (int i = 0; i < _imageArray.count; i++) {
        if ([_imageArray[i] isKindOfClass:[UIImage class]]) { // local image
            [self.images addObject:_imageArray[i]];
        }
        if ([_imageArray[i] isKindOfClass:[NSString class]]) { // internet image
            if (_placeholderImage) { // hold placeholder image if setted
                [self.images addObject:_placeholderImage];
            } else { // use NSNull object replace if not setted
                [self.images addObject:[NSNull null]];
            }
            [self.imageManager downloadImage:self.imageArray[i] index:i]; // use SRCarouselImageManager to download image
        }
    }
    
    if ([self.images[0] isKindOfClass:[NSNull class]]) {
        _currentImageView.image = nil;
    } else { // show first image or placeholder image if exists
        _currentImageView.image = self.images[0];
    }
}

- (void)setupImageDescribes {
    if (_describeArray && _describeArray.count > 0) {
        if (_describeArray.count < self.images.count) {
            NSMutableArray *arrayM = [NSMutableArray arrayWithArray:_describeArray];
            for (NSInteger i = _describeArray.count; i < self.images.count; i++) {
                [arrayM addObject:@""];
            }
            _describeArray = arrayM;
        }
        _bottomContainer = [[UIView alloc] init];
        _bottomContainer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:_bottomContainer];
        [_bottomContainer addSubview:self.descLabel];
        
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
    
    CGFloat bottomContainerHeight = 25;
    CGFloat pageControlDotWidth = 15;
    if (!_describeArray || _describeArray.count == 0) {
        _pageControl.frame = CGRectMake(width * 0.5 - _pageControl.numberOfPages * pageControlDotWidth * 0.5,
                                        height - bottomContainerHeight,
                                        _pageControl.numberOfPages * pageControlDotWidth,
                                        bottomContainerHeight);
    } else {
        _bottomContainer.frame = CGRectMake(0, height - bottomContainerHeight, width, bottomContainerHeight);
        _pageControl.frame = CGRectMake(width - _pageControl.numberOfPages * pageControlDotWidth - 5,
                                        height - bottomContainerHeight,
                                        _pageControl.numberOfPages * pageControlDotWidth,
                                        bottomContainerHeight);
        _descLabel.frame = CGRectMake(5, 0, width - 10, bottomContainerHeight);
    }
}

#pragma mark - Timer

- (void)startAutoPagingTimer {
    if (self.images.count <= 1) {
        return;
    }
    if (_autoPagingTimer) {
        [self stopAutoPagingTimer];
    }
    _autoPagingTimer = [NSTimer timerWithTimeInterval:_autoPagingInterval == 0 ? 5.0 : _autoPagingInterval
                                               target:self
                                             selector:@selector(nextPage)
                                             userInfo:nil
                                              repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_autoPagingTimer forMode:NSRunLoopCommonModes];
}

- (void)stopAutoPagingTimer {
    if (_autoPagingTimer) {
        [_autoPagingTimer invalidate];
        _autoPagingTimer = nil;
    }
}

#pragma mark - Actions

- (void)nextPage {
    CGFloat width = _scrollView.frame.size.width;
    [_scrollView setContentOffset:CGPointMake(width * 2, 0) animated:YES];
}

- (void)didTapCurrentImageView {
    if (self.block) {
        self.block(self.currentIndex);
    }
    if ([self.delegate respondsToSelector:@selector(carouselViewDidTapCarouselViewAtIndex:)]) {
        [self.delegate carouselViewDidTapCarouselViewAtIndex:self.currentIndex];
    }
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
    [self stopAutoPagingTimer]; // stop timer when dragging scrollview manually
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startAutoPagingTimer]; // start timer when stop dragging scrollview manually
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateContent]; // update content when paging finishes manually
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updateContent]; // update content when paging finishes automatically
}

- (void)updateContent {
    CGFloat width = _scrollView.frame.size.width;
    
    if (_scrollView.contentOffset.x == width) { // if paging not finished do not update content
        return;
    }
    
    _currentIndex = _nextIndex;
    _currentImageView.image = _nextImageView.image;
    _pageControl.currentPage = _currentIndex;
    if (self.describeArray.count > 0) {
        self.descLabel.text = self.describeArray[_currentIndex];
    }
    
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

- (void)setAutoPagingInterval:(NSTimeInterval)autoPagingInterval {
    if (_autoPagingInterval != autoPagingInterval) {
        _autoPagingInterval = autoPagingInterval;
        [self startAutoPagingTimer];
    }
}

+ (void)clearCachedImages {
    [SRCarouselImageManager clearCachedImages];
}

@end

#define SRImagesDirectory      [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] \
stringByAppendingPathComponent:NSStringFromClass([self class])]

//#define SRImageName(URLString) [URLString lastPathComponent]

//#define SRImagePath(URLString) [SRImagesDirectory stringByAppendingPathComponent:SRImageName(URLString)]

@interface SRCarouselImageManager ()

@property (nonatomic, strong) NSMutableDictionary *redownloadManager;

@end

@implementation SRCarouselImageManager

+ (void)load {
    NSString *imagesDirectory = SRImagesDirectory;
    BOOL isDirectory = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExists = [fileManager fileExistsAtPath:imagesDirectory isDirectory:&isDirectory];
    if (!isExists || !isDirectory) {
        [fileManager createDirectoryAtPath:imagesDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (NSString *)imagePath:(NSString *)URLString {
    NSString *imageName = nil;
    NSString *query = [NSURL URLWithString:URLString].query;
    if (query) {
        // https://yixunfiles-ali.yixun.arhieason.com/9535a537ad2538d53ec1a351deff3856_jpg.jpg?x-oss-process=image/format,png
        // https://yixunfiles-ali.yixun.arhieason.com/9535a537ad2538d53ec1a351deff3856_jpg.jpg?
        // https://yixunfiles-ali.yixun.arhieason.com/9535a537ad2538d53ec1a351deff3856_jpg.jpg
        // 9535a537ad2538d53ec1a351deff3856_jpg.jpg
        imageName = [URLString stringByReplacingOccurrencesOfString:query withString:@""];
        imageName = [imageName stringByReplacingOccurrencesOfString:@"?" withString:@""];
    }
    imageName = imageName.lastPathComponent;
    return [SRImagesDirectory stringByAppendingPathComponent:imageName];
}

- (NSMutableDictionary *)redownloadManager {
    if (!_redownloadManager) {
        _redownloadManager = [NSMutableDictionary dictionary];
    }
    return _redownloadManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _repeatCountWhenDownloadFailed = 2;
    }
    return self;
}

- (UIImage *)imageFromSandbox:(NSString *)imageURLString {
    NSString *imagePath = [self imagePath:imageURLString];
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    if (data.length > 0 ) {
        return [UIImage imageWithData:data];
    } else {
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:NULL];
    }
    return nil;
}

- (void)downloadImage:(NSString *)imageURLString index:(NSInteger)imageIndex {
    UIImage *image = [self imageFromSandbox:imageURLString];
    if (image) {
        if (self.downloadImageSuccess) {
            self.downloadImageSuccess(image, imageIndex);
        }
        return;
    }
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:imageURLString]
                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         if (error) {
                                             [self redownloadImage:imageURLString index:imageIndex error:error];
                                             return;
                                         }
                                         UIImage *image = [UIImage imageWithData:data];
                                         if (!image) {
                                             return;
                                         }
                                         if (self.downloadImageSuccess) {
                                             self.downloadImageSuccess(image, imageIndex);
                                         }
                                         if (![data writeToFile:[self imagePath:imageURLString] atomically:YES]) {
                                             NSLog(@"writeToFile Failed!");
                                         }
                                     });
                                 }] resume];
}

- (void)redownloadImage:(NSString *)imageURLString index:(NSInteger)imageIndex error:(NSError *)error {
    NSNumber *redownloadNumber = self.redownloadManager[imageURLString];
    NSInteger redownloadTimes = redownloadNumber ? redownloadNumber.integerValue : 0;
    if (self.repeatCountWhenDownloadFailed > redownloadTimes) {
        self.redownloadManager[imageURLString] = @(++redownloadTimes);
        [self downloadImage:imageURLString index:imageIndex];
        return;
    }
    if (self.downloadImageFailure) {
        self.downloadImageFailure(error, imageURLString);
    }
}

+ (void)clearCachedImages {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileNames = [fileManager contentsOfDirectoryAtPath:SRImagesDirectory error:nil];
    for (NSString *fileName in fileNames) {
        if (![fileManager removeItemAtPath:[SRImagesDirectory stringByAppendingPathComponent:fileName] error:nil]) {
            NSLog(@"removeItemAtPath Failed!");
        }
    }
}

@end
