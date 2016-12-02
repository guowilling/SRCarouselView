//
//  ViewController.m
//  SRInfiniteCarouselViewDemo
//
//  Created by 郭伟林 on 16/9/3.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRInfiniteCarouselView.h"
#import "OneViewController.h"
#import "TwoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"InfiniteCarousel";
    
    UIButton *oneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    oneBtn.frame = CGRectMake(0, 0, 200, 50);
    oneBtn.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame) - 50);
    [oneBtn setTitle:@"n + 2 个 ImageView" forState:UIControlStateNormal];
    [oneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [oneBtn addTarget:self action:@selector(oneBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:oneBtn];
    
    UIButton *twoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    twoBtn.frame = CGRectMake(0, 0, 200, 50);
    twoBtn.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame) + 50);
    [twoBtn setTitle:@"3 个 ImageView" forState:UIControlStateNormal];
    [twoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [twoBtn addTarget:self action:@selector(twoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twoBtn];
}

- (void)oneBtnAction {
    
    [self.navigationController pushViewController:[OneViewController new] animated:YES];
}

- (void)twoBtnAction {
    
    [self.navigationController pushViewController:[TwoViewController new] animated:YES];
}

@end
