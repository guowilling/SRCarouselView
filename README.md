# SRInfiniteCarouselView

Infinite carousel view with local images, urls of images or mixed of them.

## Features

* [x] Only use two UIImageView to achieve infinite carousel.
* [x] UIPageControl will be displayed on the right If there are descriptions, otherwise displayed on the center.
* [x] Not rely on any third-party libraries, use the native API to download and cache image.

## Screenshots

![image](screenshot1.jpg)
![image](screenshot2.jpg)

## Usage

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
````

````objc
// local images
NSArray *imageArray = @[[UIImage imageNamed:@"coldplay01"],
                        [UIImage imageNamed:@"coldplay02"],
                        [UIImage imageNamed:@"coldplay03"],
                        [UIImage imageNamed:@"coldplay04"]];
NSMutableArray *describeArray = [[NSMutableArray alloc] init];
for (NSInteger i = 0; i < imageArray.count; i++) {
    NSString *tempDesc = [NSString stringWithFormat:@"Image Description %zd", i];
    [describeArray addObject:tempDesc];
}
    
SRInfiniteCarouselView *imageCarouselView = [SRInfiniteCarouselView sr_carouselViewWithImageArrary:imageArray
                                                                                     describeArray:describeArray
                                                                                  placeholderImage:nil
                                                                                          delegate:self];
imageCarouselView.frame = CGRectMake(0, 264, self.view.frame.size.width, 200);
imageCarouselView.autoPagingInterval = 10.0;
[self.view addSubview:imageCarouselView];
````

````objc
// urls of images
NSArray *imageArray = @[@"http://i1.piimg.com/4851/859cc36239f5a49e.png",
                        @"http://i1.piimg.com/4851/a47d409e267eb871.png",
                        @"http://i1.piimg.com/4851/a19f19acb7551cce.png",
                        @"http://i1.piimg.com/4851/e92063eb386c232a.png"];
    
SRInfiniteCarouselView *imageCarouselView = [SRInfiniteCarouselView sr_carouselViewWithImageArrary:imageArray
                                                                                     describeArray:nil
                                                                                  placeholderImage:[UIImage imageNamed:@"placeholder_image.jpg"]
                                                                                          delegate:self];
imageCarouselView.frame = CGRectMake(0, 64, self.view.frame.size.width, 200);
[self.view addSubview:imageCarouselView];
````

````objc
// mixed of them
NSArray *imageArray = @[@"http://i1.piimg.com/4851/859cc36239f5a49e.png",
                        @"http://i1.piimg.com/4851/a47d409e267eb871.png",
                        [UIImage imageNamed:@"coldplay03"],
                        [UIImage imageNamed:@"coldplay04"]];
SRInfiniteCarouselView *imageCarouselView = [SRInfiniteCarouselView sr_carouselViewWithImageArrary:imageArray
                                                                                     describeArray:nil
                                                                                  placeholderImage:nil
                                                                                          delegate:self];
imageCarouselView.frame = CGRectMake(0, 464, self.view.frame.size.width, 200);
imageCarouselView.autoPagingInterval = 10.0;
[self.view addSubview:imageCarouselView];
````

## Updates

### 2017.01.11
Redesign class structure, add a class to manage network images. It can be applied to other network image download and cache place.   
If you do not like the new way of using, you can also use the previous way, the SRInfiniteCarouselViewDeprecated classes are in 'Deprecated' folder.

## More

Author: [guowilling](https://github.com/guowilling)  
Email: <guowilling90@gmail.com>   
If you have any questions, submit an issue or email me.