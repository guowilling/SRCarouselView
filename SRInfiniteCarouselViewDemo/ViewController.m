//
//  ViewController.m
//  SRInfiniteCarouselViewDemo
//
//  Created by 郭伟林 on 16/9/3.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRInfiniteCarouselView.h"

@interface ViewController () <SRInfiniteCarouselViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"SRInfiniteCarouselView";
    
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
}

- (void)infiniteCarouselViewDidTapImageAtIndex:(NSInteger)index {
    
    NSLog(@"%zd", index);
}

@end
