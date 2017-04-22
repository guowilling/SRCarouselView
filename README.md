# SRInfiniteCarouselView

## Features

* Only use two UIImageView to achieve infinite carousel.
* UIPageControl will be displayed on the right If there are descriptions, otherwise displayed on the center.
* Do not rely on any third-party libraries, use the native API to download and cache images.
* Support to manually clear images that are cached in the sandbox.

## Show

![image](show1.png)
![image](show2.png)

## Installation

### CocoaPods
> Add **pod 'SRInfiniteCarouselView'** to the Podfile, then run **pod install** in the terminal.

### Manual
> Drag the **SRInfiniteCarouselView** folder to the project.

## APIs

````objc
/**
 Creates and returns a SRInfiniteCarouselView object with imageArrary, describeArray, placeholderImage and delegate.
 
 @param imageArrary      The local images or the urls of images or mixed of them.
 @param describeArray    The describes which in the same order as the images.
 @param placeholderImage The placeholder image when internet images have not download.
 @param delegate         The delegate of this object.
 @return A SRInfiniteCarouselView object.
 */
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage delegate:(id<SRImageCarouselViewDelegate>)delegate;
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage;
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray;
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary;
````

## Usage

````objc
// Network Images
NSArray *imageArray = @[@"http://i1.piimg.com/4851/859cc36239f5a49e.png",
                        @"http://i1.piimg.com/4851/a47d409e267eb871.png",
                        @"http://i1.piimg.com/4851/a19f19acb7551cce.png",
                        @"http://i1.piimg.com/4851/e92063eb386c232a.png"];
    
SRImageCarouselView *imageCarouselView = [SRImageCarouselView sr_imageCarouselViewWithImageArrary:imageArray
                                                                                    describeArray:nil
                                                                                 placeholderImage:[UIImage imageNamed:@"placeholder"]
                                                                                         delegate:self];
imageCarouselView.frame = CGRectMake(0, 64, self.view.frame.size.width, 200);
[self.view addSubview:imageCarouselView];
````

````objc
// Local Images
NSArray *imageArray = @[[UIImage imageNamed:@"coldplay01"],
                        [UIImage imageNamed:@"coldplay02"],
                        [UIImage imageNamed:@"coldplay03"],
                        [UIImage imageNamed:@"coldplay04"]];
NSMutableArray *describeArray = [[NSMutableArray alloc] init];
for (NSInteger i = 0; i < imageArray.count; i++) {
    NSString *tempDesc = [NSString stringWithFormat:@"Image Description %zd", i];
    [describeArray addObject:tempDesc];
}
    
SRImageCarouselView *imageCarouselView = [SRImageCarouselView sr_imageCarouselViewWithImageArrary:imageArray
                                                                                    describeArray:describeArray
                                                                                 placeholderImage:nil
                                                                                         delegate:self];
imageCarouselView.frame = CGRectMake(0, 264, self.view.frame.size.width, 200);
imageCarouselView.timeInterval = 10.0;
[self.view addSubview:imageCarouselView];
````

````objc
// Mixed Images
NSArray *imageArray = @[@"http://i1.piimg.com/4851/859cc36239f5a49e.png",
                        @"http://i1.piimg.com/4851/a47d409e267eb871.png",
                        [UIImage imageNamed:@"coldplay03"],
                        [UIImage imageNamed:@"coldplay04"]];
SRInfiniteCarouselView *imageCarouselView = [SRInfiniteCarouselView sr_carouselViewWithImageArrary:imageArray
                                                                                     describeArray:nil
                                                                                  placeholderImage:nil
                                                                                          delegate:self];
imageCarouselView.frame = CGRectMake(0, 464, self.view.frame.size.width, 200);
imageCarouselView.timeInterval = 10.0;
[self.view addSubview:imageCarouselView];
````

## Custom Settings

````objc
/**
 The interval of automatic paging, default is 5.0s.
 */
@property (nonatomic, assign) NSTimeInterval autoPagingInterval;

/**
 The tint color of current page indicator.
 */
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

/**
 The tint color of other page indicator.
 */
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

/**
 The image of current page indicator.
 */
@property (nonatomic, strong) UIImage *currentPageIndicatorImage;

/**
 The image of other page indicator.
 */
@property (nonatomic, strong) UIImage *pageIndicatorImage;
````

## Significant Updates

### 2017.01.11
> Redesign class structure, add a class to manage network images. It can be applied to other network image download and cache place.   
> If you do not like the new way of using, you can also use the previous way, the SRInfiniteCarouselViewDeprecated classes are in 'Deprecated' folder.