//
//  ViewController.m
//  UIviewDemo
//
//  Created by tenghu on 2017/10/13.
//  Copyright © 2017年 tenghu. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(30, 80, 80, 80)];
    view1.backgroundColor = [UIColor redColor];
    [view1 k_cornerWithRadius:40];
    [self.view addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(150, 80, 80, 80)];
    view2.backgroundColor = [UIColor redColor];
    [view2 k_topCornerWithRadius:10];
    [self.view addSubview:view2];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(270, 80, 80, 80)];
    view3.backgroundColor = [UIColor redColor];
    [view3 k_bottomCornerWithRadius:10];
    [self.view addSubview:view3];
    
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(30, 200, 80, 80)];
    view4.backgroundColor = [UIColor redColor];
    [view4 k_cornerWithRadius:40 borderColor:[UIColor blueColor] borderWidth:2];
    [self.view addSubview:view4];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
