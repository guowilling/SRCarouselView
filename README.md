# SRInfiniteCarouselView

## Features

* Only use two UIImageView to achieve infinite carousel.
* Do not rely on any third-party libraries, use the native API to download and cache images.
* Support for manually deleting cached carousel images in the sandbox.
* UIPageControl will be displayed on the right If there are descriptions of the contents of the images or displayed on the center.

***

* 只使用了两个 UIImageView 实现无线轮播.
* 使用原生 API 下载和缓存图片.
* 支持手动删除缓存在沙盒中的图片.
* 如果图片设置了描述, UIPageControl 会显示在底部的右边, 否则会显示在底部中间.

## Show Pictures

![image](./show.gif)
![image](./show.png)

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
// Delegate Method
- (void)infiniteCarouselViewDidTapImageAtIndex:(NSInteger)index {
    
    NSLog(@"%zd", index);
}
````

````objc
// Clear Images In Sandbox
[[SRImageManager shareManager] clearCachedImages];
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

## Update

### 2017.01.10
> Redesign class structure, add a class to manage network images. it can be applied to other network image download and cache place.   
> If you do not like the new way of using, you can also use the previous way, the SRInfiniteCarouselViewDeprecated0 class is in 'Deprecated' folder.

**If you have any question, please issue or contact me.**   
**If this repo helps you, please give it a star.**  
**Have Fun.**
