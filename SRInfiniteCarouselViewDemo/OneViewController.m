//
//  OneViewController.m
//  SRInfiniteCarouselViewDemo
//
//  Created by Willing Guo on 16/11/28.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "OneViewController.h"
#import "SRInfiniteCarouselView.h"

@interface OneViewController () <SRInfiniteCarouselViewDelegate>

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    {
        // Local images
        NSArray *imageNames = @[@"coldplay01", @"coldplay02", @"coldplay03", @"coldplay04"];
        SRInfiniteCarouselView *infiniteCarouselView = \
        [SRInfiniteCarouselView sr_infiniteCarouselViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 200)
                                                      imageNames:imageNames
                                                    timeInterval:5.0
                                   currentPageIndicatorTintColor:nil
                                          pageIndicatorTintColor:nil
                                                        delegate:self];
        
        //infiniteCarouselView.pageControlBottomDistance = 20.0f;
        //infiniteCarouselView.forbidScrolling = YES;
        //infiniteCarouselView.currentPageIndicatorTintColor = [UIColor redColor];
        //infiniteCarouselView.pageIndicatorTintColor = [UIColor orangeColor];
        [self.view addSubview:infiniteCarouselView];
    }
    
    {
        // Internet images
        NSArray *imageURLStrings = @[@"http://i1.piimg.com/4851/859cc36239f5a49e.png",
                                     @"http://i1.piimg.com/4851/a47d409e267eb871.png",
                                     @"http://i1.piimg.com/4851/a19f19acb7551cce.png",
                                     @"http://i1.piimg.com/4851/e92063eb386c232a.png"];
        SRInfiniteCarouselView *infiniteCarouselView = \
        [SRInfiniteCarouselView sr_infiniteCarouselViewWithFrame:CGRectMake(0, 64 + 200, self.view.frame.size.width, 200)
                                                       imageURLs:imageURLStrings
                                            placeholderImageName:nil
                                                    timeInterval:5.0
                                   currentPageIndicatorTintColor:nil
                                          pageIndicatorTintColor:nil
                                                        delegate:self];
        
        [self.view addSubview:infiniteCarouselView];
    }
}

- (void)infiniteCarouselView:(SRInfiniteCarouselView *)infiniteCarouselView didClickImageAtIndex:(NSInteger)index {
    
    NSLog(@"didClickImageAtIndex: %zd", index);
}

@end
