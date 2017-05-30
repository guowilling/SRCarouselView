//
//  ViewController.m
//  SRCarouselViewDemo
//
//  Created by 郭伟林 on 16/9/3.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRCarouselView.h"

@interface ViewController () <SRCarouselViewDelegate>

@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self carouselViewWithLocalImages];
    
    [self carouselViewWithNetworkImages];
    
    [self carouselViewWithMixedImages];
}

- (void)clearCachedImages {
    
    [SRCarouselImageManager clearCachedImages];
}

- (void)carouselViewWithLocalImages {
    
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
}

- (void)carouselViewWithNetworkImages {
    
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
    SRCarouselView *carouselView = [SRCarouselView sr_carouselViewWithImageArrary:imageArray describeArray:nil placeholderImage:[UIImage imageNamed:@"placeholder_image.jpg"] block:^(NSInteger index) {
        NSLog(@"index: %zd", index);
    }];
    carouselView.frame = CGRectMake(0, 245, self.view.frame.size.width, 200);
    [self.view addSubview:carouselView];
}

- (void)carouselViewWithMixedImages {
    
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
}

- (void)didTapCarouselViewAtIndex:(NSInteger)index {
    
    NSLog(@"index: %zd", index);
}

@end
