//
//  PersonalCenterViewController.m
//  SlidingOfQQDemo
//  xib
//
//  Created by B.Dog on 16/3/2.
//  Copyright © 2016年 JKSoft. All rights reserved.
//

#import "PersonalCenterViewController.h"

#pragma mark - ViewControllers_Import
#pragma mark - Views_Import
#pragma mark - models_Import
#pragma mark - cells_Import

#pragma mark - define

@interface PersonalCenterViewController ()

@end

@implementation PersonalCenterViewController

#pragma mark -
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)sayHi {
    NSLog(@"hi~");
}

#pragma mark -
#pragma mark initialize interface
// 创建页面内控件的地方。
- (void)JK_createViews
{
    
}

// 创建页面内控件事件的地方
- (void)JK_createEvents
{
    
}

// 如果页面加载过程需要读取数据, 则写在这个地方。
- (void)Jk_loadData
{
    
}

#pragma mark -
#pragma mark methods

#pragma mark -
#pragma mark button response

#pragma mark -
#pragma mark delegates

#pragma mark -
#pragma mark getters

#pragma mark -
#pragma mark setters


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
