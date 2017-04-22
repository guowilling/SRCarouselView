//
//  ViewController.m
//  SRInfiniteCarouselViewDemo
//
//  Created by 郭伟林 on 16/9/3.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRInfiniteCarouselView.h"
#import "SRImageManager.h"

@interface ViewController () <SRImageCarouselViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"SRInfiniteCarouselView";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"CLEAR"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:[SRImageManager class]
                                                                             action:@selector(clearCachedImages)];
    
    {
        // Network Images
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
    }

    {
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
        
        SRInfiniteCarouselView *imageCarouselView = [SRInfiniteCarouselView sr_carouselViewWithImageArrary:imageArray
                                                                                             describeArray:describeArray
                                                                                          placeholderImage:nil
                                                                                                  delegate:self];
        imageCarouselView.frame = CGRectMake(0, 264, self.view.frame.size.width, 200);
        imageCarouselView.autoPagingInterval = 10.0;
        [self.view addSubview:imageCarouselView];
    }
    
    {
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
        imageCarouselView.autoPagingInterval = 10.0;
        [self.view addSubview:imageCarouselView];
    }
}

- (void)imageCarouselViewDidTapImageAtIndex:(NSInteger)index {
    
    NSLog(@"imageCarouselViewDidTapImageAtIndex: %zd", index);
}

@end
