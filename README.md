# SRInfiniteCarouselView

### Easy to create infinite carousel view with the urls of images or local images.

## Features

* Only use two UIImageView to achieve infinite carousel.
* Do not rely on any third-party libraries, use the native API to download images and avoid duplication of downloads and other issues.
* Support for manually deleting cached carousel images in the sandbox
* UIPageControl will be displayed on the right If there are descriptions of the contents of the images or displayed on the center.

## Show pictures


## Usage

````objc
{
    // URLs of images
    NSArray *imageArray = @[@"http://i1.piimg.com/4851/859cc36239f5a49e.png",
                            @"http://i1.piimg.com/4851/a47d409e267eb871.png",
                            @"http://i1.piimg.com/4851/a19f19acb7551cce.png",
                            @"http://i1.piimg.com/4851/e92063eb386c232a.png"];
    
    SRInfiniteCarouselView *infiniteCarouselView = [SRInfiniteCarouselView sr_infiniteCarouselViewWithImageArrary:imageArray
                                                                                                    describeArray:nil
                                                                                                 placeholderImage:[UIImage imageNamed:@"placeholder"]
                                                                                                         delegate:self];
    infiniteCarouselView.frame = CGRectMake(0, 64, self.view.frame.size.width, 200);
    [self.view addSubview:infiniteCarouselView];
}

{
    // Local images.
    NSArray *imageArray = @[[UIImage imageNamed:@"coldplay01"],
                            [UIImage imageNamed:@"coldplay02"],
                            [UIImage imageNamed:@"coldplay03"],
                            [UIImage imageNamed:@"coldplay04"]];
    NSMutableArray *describeArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < imageArray.count; i++) {
        NSString *tempDesc = [NSString stringWithFormat:@"图片描述%zd", i];
        [describeArray addObject:tempDesc];
    }
    
    SRInfiniteCarouselView *infiniteCarouselView = [SRInfiniteCarouselView sr_infiniteCarouselViewWithImageArrary:imageArray
                                                                                                    describeArray:describeArray
                                                                                                 placeholderImage:nil
                                                                                                         delegate:self];
    infiniteCarouselView.frame = CGRectMake(0, 264, self.view.frame.size.width, 200);
    infiniteCarouselView.timeInterval = 10.0;
    [self.view addSubview:infiniteCarouselView];
}

- (void)infiniteCarouselViewDidTapImageAtIndex:(NSInteger)index {
    
    NSLog(@"%zd", index);
}
````

## Custom Settings

````objc
/**
 The time interval of auto Paging, Default is 5.0s.
 */
@property (nonatomic, assign) NSTimeInterval timeInterval;

/**
 Current page indicator tint color.
 */
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

/**
 Other page indicator tint color.
 */
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

/**
 Current page indicator image.
 */
@property (nonatomic, strong) UIImage *currentPageIndicatorImage;

/**
 Other page indicator image.
 */
@property (nonatomic, strong) UIImage *pageIndicatorImage;
````

## Public methods

````objc
/**
 Clear the images cache in the sandbox.
 */
- (void)clearImagesCache;
````

**If you have any question, please issue or contact me.**   
**If this repo helps you, please give it a star.**  
**Have Fun.**
