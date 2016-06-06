//
//  HomePageViewController.m
//  SlidingOfQQDemo
//  xib
//
//  Created by B.Dog on 16/3/2.
//  Copyright © 2016年 JKSoft. All rights reserved.
//

#import "HomePageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>


//#import "SimpleMacro.h"
#import "SlidingMenuManger.h"

#pragma mark - ViewControllers_Import
#pragma mark - Views_Import
#pragma mark - models_Import
#pragma mark - cells_Import

#pragma mark - define

@interface HomePageViewController ()

@property (nonatomic, assign) BOOL isPersonalCenderShowing;

@end

@implementation HomePageViewController

#pragma mark -
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBarItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initialize interface
- (void)setupNavigationBarItems {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"homePage_rightBar"] style:UIBarButtonItemStylePlain target:[SlidingMenuManger manager] action:@selector(pressTheSwitchOfMenu)];
}

#pragma mark - methods

#pragma mark - response
//- (void)panForPersonalCenter:(UIPanGestureRecognizer *)pan {
//    
//    CGPoint pt = [pan translationInView:pan.view];
//    NSLog(@"%@", NSStringFromCGPoint(pt));
//    CGFloat width = CGRectGetWidth(pan.view.frame) - pt.x;
//    CGFloat xs = width*1.0/[UIScreen mainScreen].bounds.size.width;
//    CGFloat ys = xs*[UIScreen mainScreen].bounds.size.height/[UIScreen mainScreen].bounds.size.width;
//    
//    CGFloat height = ys*[UIScreen mainScreen].bounds.size.height;
//    
//    pan.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width
//-width,
//                                ([UIScreen mainScreen].bounds.size.height-height)/2.0,
//                                width,
//                                height);
//    
//    
//}



#pragma mark -
#pragma mark delegates

#pragma mark -
#pragma mark getters

#pragma mark -
#pragma mark setters

@end
