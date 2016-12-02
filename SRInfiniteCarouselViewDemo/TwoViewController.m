//
//  TwoViewController.m
//  SRInfiniteCarouselViewDemo
//
//  Created by Willing Guo on 16/11/28.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "TwoViewController.h"
#import "SRInifiniteCarouselExtensionView.h"

@interface TwoViewController () <SRInifiniteCarouselExtensionViewDelegate>

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    {
        // Local images
        NSArray *imageNames = @[[UIImage imageNamed:@"coldplay01"],
                                [UIImage imageNamed:@"coldplay02"],
                                [UIImage imageNamed:@"coldplay03"],
                                [UIImage imageNamed:@"coldplay04"]];
        SRInifiniteCarouselExtensionView *infiniteCarouselView = \
        [SRInifiniteCarouselExtensionView sr_infiniteCarouselViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 200)
                                                                imageNames:imageNames
                                                              timeInterval:5.0
                                             currentPageIndicatorTintColor:nil
                                                    pageIndicatorTintColor:nil
                                                                  delegate:self];
        [self.view addSubview:infiniteCarouselView];
    }
    
    {
        // Internet images
        NSArray *imageURLStrings = @[@"http://i1.piimg.com/4851/859cc36239f5a49e.png",
                                     @"http://i1.piimg.com/4851/a47d409e267eb871.png",
                                     @"http://i1.piimg.com/4851/a19f19acb7551cce.png",
                                     @"http://i1.piimg.com/4851/e92063eb386c232a.png"];
        SRInifiniteCarouselExtensionView *infiniteCarouselView = \
        [SRInifiniteCarouselExtensionView sr_infiniteCarouselViewWithFrame:CGRectMake(0, 64 + 200, self.view.frame.size.width, 200)
                                                                 imageURLs:imageURLStrings
                                                      placeholderImageName:nil
                                                              timeInterval:5.0
                                             currentPageIndicatorTintColor:nil
                                                    pageIndicatorTintColor:nil
                                                                  delegate:self];
        
        [self.view addSubview:infiniteCarouselView];
    }
}

- (void)infiniteCarouselView:(SRInifiniteCarouselExtensionView *)infiniteCarouselView didClickImageAtIndex:(NSInteger)index {
    
    NSLog(@"didClickImageAtIndex: %zd", index);
}

@end
