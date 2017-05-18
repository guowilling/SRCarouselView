# SRCarouselView

A carousel view that only uses two UIImageView to achieve infinite carousel. It is created with an array that can contain local images, network images or both of them. UIPageControl will be displayed on the right If there are descriptions, otherwise displayed on the center. Not rely on any third-party libraries, use the native api to download and cache image.

![image](./screenshots.png)

## Usage

````objc
/**
 Creates and returns a infinite carousel view with imageArrary, describeArray, placeholderImage and delegate.
 
 @param imageArrary      An array contains local images, or urls of images, or mixed of them.
 @param describeArray    An array contains image describes which in the same order as the images.
 @param placeholderImage The placeholder image when network image have not downloaded.
 @param delegate         The receiver’s delegate object.
 @return A newly infinite carousel view.
 */
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage delegate:(id<SRCarouselViewDelegate>)delegate;
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray placeholderImage:(UIImage *)placeholderImage;
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary describeArray:(NSArray *)describeArray;
+ (instancetype)sr_carouselViewWithImageArrary:(NSArray *)imageArrary;
````

````objc
// Local Images.
NSArray *imageArray = @[[UIImage imageNamed:@"logo01"],
                        [UIImage imageNamed:@"logo02"],
                        [UIImage imageNamed:@"logo03"],
                        [UIImage imageNamed:@"logo04"],
                        [UIImage imageNamed:@"logo05"]];
NSMutableArray *describeArray = [[NSMutableArray alloc] init];
for (NSInteger i = 0; i < imageArray.count; i++) {
    NSString *tempDesc = [NSString stringWithFormat:@"Image Description %zd", i + 1];
    [describeArray addObject:tempDesc];
}
SRCarouselView *carouselView = [SRCarouselView sr_carouselViewWithImageArrary:imageArray describeArray:nil placeholderImage:nil delegate:self];
carouselView.frame = CGRectMake(0, 44, self.view.frame.size.width, 200);
carouselView.autoPagingInterval = 10.0;
[self.view addSubview:carouselView];
````

````objc
// Network Images.
NSArray *imageArray = @[@"http://i4.buimg.com/593517/ad2538d53ec1a351.jpg",
                        @"http://i1.piimg.com/593517/25a7b62e81cafc4e.jpg",
                        @"http://i1.piimg.com/593517/c3412974369d544a.jpg",
                        @"http://i1.piimg.com/593517/d057e12c45ecbcb7.jpg",
                        @"http://i1.piimg.com/593517/560715fb9a38df95.jpg"];
NSMutableArray *describeArray = [[NSMutableArray alloc] init];
for (NSInteger i = 0; i < imageArray.count; i++) {
    NSString *tempDesc = [NSString stringWithFormat:@"Image Description %zd", i];
    [describeArray addObject:tempDesc];
}
SRCarouselView *carouselView = [SRCarouselView sr_carouselViewWithImageArrary:imageArray describeArray:nil placeholderImage:[UIImage imageNamed:@"placeholder_image.jpg"] delegate:self];
carouselView.frame = CGRectMake(0, 245, self.view.frame.size.width, 200);
[self.view addSubview:carouselView];
````

````objc
// Local and Network Images.
NSArray *imageArray = @[@"http://i4.buimg.com/593517/ad2538d53ec1a351.jpg",
                        @"http://i1.piimg.com/593517/25a7b62e81cafc4e.jpg",
                        [UIImage imageNamed:@"logo03"],
                        [UIImage imageNamed:@"logo04"],
                        [UIImage imageNamed:@"logo05"]];
NSMutableArray *describeArray = [[NSMutableArray alloc] init];
for (NSInteger i = 0; i < imageArray.count; i++) {
    NSString *tempDesc = [NSString stringWithFormat:@"Image Description"];
    [describeArray addObject:tempDesc];
}
SRCarouselView *carouselView = [SRCarouselView sr_carouselViewWithImageArrary:imageArray describeArray:describeArray placeholderImage:[UIImage imageNamed:@"placeholder"] delegate:self];
carouselView.frame = CGRectMake(0, 446, self.view.frame.size.width, 200);
carouselView.autoPagingInterval = 10.0;
[self.view addSubview:carouselView];
````

## Significant Update

### 2017.01.11
Redesign class structure, add a class to manage network images. It can be applied to other network image download and cache place.   