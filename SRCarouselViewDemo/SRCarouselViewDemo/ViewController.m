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

- (void)carouselViewWithLocalImages {
    NSArray *imageArray = @[[UIImage imageNamed:@"logo01.jpg"],
                            [UIImage imageNamed:@"logo02.jpg"],
                            [UIImage imageNamed:@"logo03.jpg"],
                            [UIImage imageNamed:@"logo04.jpg"],
                            [UIImage imageNamed:@"logo05.jpg"]];
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
    NSArray *imageArray = @[@"https://yixunfiles-ali.yixun.arhieason.com/9535a537ad2538d53ec1a351deff3856_jpg.jpg?x-oss-process=image/format,png",
                            @"https://yixunfiles-ali.yixun.arhieason.com/8f8b02a025a7b62e81cafc4e9d89f70e_jpg.jpg?x-oss-process=image/format,png",
                            @"https://yixunfiles-ali.yixun.arhieason.com/6c72618dc3412974369d544a2734d5cb_jpg.jpg?x-oss-process=image/format,png",
                            @"https://yixunfiles-ali.yixun.arhieason.com/63a0bb8cd057e12c45ecbcb7f24e4ecf_jpg.jpg?x-oss-process=image/format,png",
                            @"https://yixunfiles-ali.yixun.arhieason.com/2393d812560715fb9a38df9550b1f749_jpg.jpg?x-oss-process=image/format,png"];
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
    NSArray *imageArray = @[@"https://yixunfiles-ali.yixun.arhieason.com/9535a537ad2538d53ec1a351deff3856_jpg.jpg?x-oss-process=image/format,png",
                            @"https://yixunfiles-ali.yixun.arhieason.com/8f8b02a025a7b62e81cafc4e9d89f70e_jpg.jpg?x-oss-process=image/format,png",
                            [UIImage imageNamed:@"logo03.jpg"],
                            [UIImage imageNamed:@"logo04.jpg"],
                            [UIImage imageNamed:@"logo05.jpg"]];
    NSMutableArray *describeArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < imageArray.count; i++) {
        NSString *tempDesc = [NSString stringWithFormat:@"Image Description"];
        [describeArray addObject:tempDesc];
    }
    SRCarouselView *carouselView = [SRCarouselView sr_carouselViewWithImageArrary:imageArray describeArray:describeArray placeholderImage:[UIImage imageNamed:@"placeholder.png"] delegate:self];
    carouselView.frame = CGRectMake(0, 446, self.view.frame.size.width, 200);
    carouselView.autoPagingInterval = 10.0;
    [self.view addSubview:carouselView];
}

- (void)carouselViewDidTapCarouselViewAtIndex:(NSInteger)index {
    NSLog(@"carouselViewDidTapCarouselViewAtIndex index: %zd", index);
}

@end
