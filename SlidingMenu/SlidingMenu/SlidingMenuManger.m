//
//  SlidingMenuManger.m
//  SlidingOfQQDemo
//
//  Created by B.Dog on 16/3/3.
//  Copyright © 2016年 JKSoft. All rights reserved.
//

#import "SlidingMenuManger.h"


static CGFloat const xScale = 0.5;
static CGFloat const menuWidth = 300;

static const NSTimeInterval animationDuration = 0.5f;  //动画时间
static const NSTimeInterval animationOpenSpringDamping = 1.0f; //打开的弹簧时间
static const CGFloat animationOpenSpringInitialVelocity = 0.05f; //打开的弹簧初始速度
static const CGFloat animationCloseSpringDamping = 1.0; //关闭的弹簧时间
static const CGFloat animationCloseSpringInitialVelocity = 0.2f; //关闭的弹簧初始速度


@interface SlidingMenuManger ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIViewController *mainViewController;
@property (nonatomic, strong) UIViewController *menuViewController;
@property (nonatomic, strong) UIViewController *firstViewController;
@property (nonatomic, strong) UIViewController *rootViewController;

@property (nonatomic, assign) CGRect menuOrignalFrame;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipe;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipe;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation SlidingMenuManger

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)manager {
    static SlidingMenuManger *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SlidingMenuManger alloc] init];
    });
    return manager;
}

- (void)startWithMainViewController:(UIViewController *)mainViewController
                 menuViewController:(UIViewController *)menuViewController
                        slidingType:(SlidingType)slidingType{
    
    self.mainViewController = mainViewController;
    self.menuViewController = menuViewController;
    
    if (menuViewController && mainViewController) {
        
        self.slidingType = slidingType;
        
        
        switch (_slidingType) {
            case SlidingTypeFromLeftScale:
            case SlidingTypeFromLeft: {
                _menuOrignalFrame = [UIScreen mainScreen].bounds;
                self.rootViewController = [[UIViewController alloc] init];
                [self.rootViewController addChildViewController:mainViewController];
                [self.rootViewController addChildViewController:menuViewController];
                [self.rootViewController.view addSubview:_menuViewController.view];
                [self.rootViewController.view addSubview:_mainViewController.view];
            } break;
            
            case SlidingTypeFromTop: {
//未完待续
                _menuOrignalFrame = [UIScreen mainScreen].bounds;
                _menuOrignalFrame.origin.y = -_menuOrignalFrame.size.height;
                
                self.rootViewController = _mainViewController;
                UINavigationController *mainNavi = (UINavigationController *)((UITabBarController *)_mainViewController).viewControllers.firstObject;
                UIViewController *mainVC = mainNavi.viewControllers.firstObject;
                
                _menuViewController.view.frame = _menuOrignalFrame;
//                UIViewController *VC = [[UIViewController alloc] init];
//                VC.view.frame = _menuOrignalFrame;
//                VC.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1];
//                [mainVC.view addSubview:VC.view];
                [mainVC.view addSubview:_menuViewController.view];
            } break;
            
            default:
            break;
        }
        
        [UIApplication sharedApplication].keyWindow.rootViewController = nil;
        [UIApplication sharedApplication].keyWindow.rootViewController = _rootViewController;
        
        self.shouldPan = YES;
        self.shouldSwipe = YES;
        self.shouldTapToShutDown = YES;
    }
}

#pragma mark - menu action
- (void)shutDownMemuViewController {
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:animationDuration delay:0 usingSpringWithDamping:animationCloseSpringDamping initialSpringVelocity:animationCloseSpringInitialVelocity options:UIViewAnimationOptionCurveLinear animations:^{
        weakSelf.mainViewController.view.frame = _menuOrignalFrame;//[UIScreen mainScreen].bounds;
    } completion:^(BOOL finished) {
        
        self.isMenuShowing = NO;
    }];
    
}

- (void)showMemuViewController {
    CGRect newFrame = _mainViewController.view.frame;
    UIViewController *temp = nil;
    switch (_slidingType) {
        case SlidingTypeFromLeftScale: {
            temp = self.mainViewController;
            newFrame = [self newFameToShowWhenSlidingTypeFromLeftScaleWith:newFrame];
        } break;
        case SlidingTypeFromLeft: {
            temp = self.mainViewController;
            newFrame = [self newFameToShowWhenSlidingTypeFromLeftWith:newFrame];
        } break;
        case SlidingTypeFromTop: {
            temp = self.menuViewController;
            newFrame = [self newFameToShowWhenSlidingTypeFromTopWith:newFrame];
        } break;
        
        default:
        break;
    }
    newFrame = CGRectIntegral(newFrame);
    
//    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:animationDuration delay:0 usingSpringWithDamping:animationOpenSpringDamping initialSpringVelocity:animationOpenSpringInitialVelocity options:UIViewAnimationOptionCurveLinear  animations:^{
      
        temp.view.frame = newFrame;
    } completion:^(BOOL finished) {
        
        self.isMenuShowing = YES;
    }];

}

- (CGRect)newFameToShowWhenSlidingTypeFromLeftScaleWith:(CGRect)newFrame {
    newFrame.size.width = xScale*[UIScreen mainScreen].bounds.size.width;
    newFrame.size.height = CGRectGetWidth(newFrame)*[UIScreen mainScreen].bounds.size.height/[UIScreen mainScreen].bounds.size.width;
    newFrame.origin.x = (1-xScale)*[UIScreen mainScreen].bounds.size.width;
    newFrame.origin.y = ([UIScreen mainScreen].bounds.size.height-CGRectGetHeight(newFrame))/2;
    return newFrame;
}

- (CGRect)newFameToShowWhenSlidingTypeFromLeftWith:(CGRect)newFrame {
    newFrame.origin.x = menuWidth;
    return newFrame;
}

- (CGRect)newFameToShowWhenSlidingTypeFromTopWith:(CGRect)newFrame {
    newFrame.origin.y = 0;
    return newFrame;
}

- (void)pressTheSwitchOfMenu {
    if (_isMenuShowing) {
        [self shutDownMemuViewController];
    } else {
        [self showMemuViewController];
    }
}

#pragma mark - gestures

- (void)panWhenSlidingTypeFromLeftScale:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:_mainViewController.view];
    if (CGRectGetMinX(_mainViewController.view.frame)+point.x >= 0 &&
        CGRectGetMinX(_mainViewController.view.frame)+point.x <= (1-xScale)*[UIScreen mainScreen].bounds.size.width) {
        
        CGRect newFrame = _mainViewController.view.frame;
        newFrame.origin.x = CGRectGetMinX(newFrame)+point.x;
        newFrame.size.width = [UIScreen mainScreen].bounds.size.width - CGRectGetMinX(newFrame);
        newFrame.size.height = CGRectGetWidth(newFrame)*[UIScreen mainScreen].bounds.size.height/[UIScreen mainScreen].bounds.size.width;
        newFrame.origin.y = ([UIScreen mainScreen].bounds.size.height-CGRectGetHeight(newFrame))/2;
        newFrame = CGRectIntegral(newFrame);
        _mainViewController.view.frame = newFrame;
        [pan setTranslation:CGPointZero inView:_mainViewController.view];
        //手势结束后修正位置
        if (pan.state == UIGestureRecognizerStateEnded) {
            if (CGRectGetMinX(_mainViewController.view.frame) > (1-xScale)*[UIScreen mainScreen].bounds.size.width/2) {
                [self showMemuViewController];
            } else if (CGRectGetMinX(_mainViewController.view.frame) < 0) {
                [self shutDownMemuViewController];
            } else {
                [self shutDownMemuViewController];
            }
        }
    }
}

- (void)panWhenSlidingTypeFromLeft:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:_mainViewController.view];
    if (CGRectGetMinX(_mainViewController.view.frame)+point.x >= 0 &&
        CGRectGetMinX(_mainViewController.view.frame)+point.x <= menuWidth) {
        CGRect newFrame = _mainViewController.view.frame;
        newFrame.origin.x = CGRectGetMinX(newFrame)+point.x;
        _mainViewController.view.frame = newFrame;
        [pan setTranslation:CGPointZero inView:_mainViewController.view];
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (CGRectGetMinX(_mainViewController.view.frame) > menuWidth/2) {
            [self showMemuViewController];
        } else if (CGRectGetMinX(_mainViewController.view.frame) < 0) {
            [self shutDownMemuViewController];
        } else {
            [self shutDownMemuViewController];
        }
    }
}


- (void)panAction:(UIPanGestureRecognizer *)pan {
    
    switch (_slidingType) {
        case SlidingTypeFromLeftScale: {
            [self panWhenSlidingTypeFromLeftScale:pan];
        } break;
        case SlidingTypeFromLeft: {
            [self panWhenSlidingTypeFromLeft:pan];
        } break;
        
        default:
        break;
    }
//    CGPoint point = [pan translationInView:_mainViewController.view];
//    NSLog(@"%f", point.x);
//    if (_shouldScale) {
//        
//        if (CGRectGetMinX(_mainViewController.view.frame)+point.x >= 0 &&
//            CGRectGetMinX(_mainViewController.view.frame)+point.x <= (1-xScale)*[UIScreen mainScreen].bounds.size.width) {
//            
//            CGRect newFrame = _mainViewController.view.frame;
//            newFrame.origin.x = CGRectGetMinX(newFrame)+point.x;
//            newFrame.size.width = [UIScreen mainScreen].bounds.size.width - CGRectGetMinX(newFrame);
//            newFrame.size.height = CGRectGetWidth(newFrame)*[UIScreen mainScreen].bounds.size.height/[UIScreen mainScreen].bounds.size.width;
//            newFrame.origin.y = ([UIScreen mainScreen].bounds.size.height-CGRectGetHeight(newFrame))/2;
//            newFrame = CGRectIntegral(newFrame);
//            _mainViewController.view.frame = newFrame;
//            [pan setTranslation:CGPointZero inView:_mainViewController.view];
//            //手势结束后修正位置
//            if (pan.state == UIGestureRecognizerStateEnded) {
//                if (CGRectGetMinX(_mainViewController.view.frame) > (1-xScale)*[UIScreen mainScreen].bounds.size.width/2) {
//                    [self showMemuViewController];
//                } else if (CGRectGetMinX(_mainViewController.view.frame) < 0) {
//                    [self shutDownMemuViewController];
//                } else {
//                    [self shutDownMemuViewController];
//                }
//            }
//        }
//    } else {
//        if (CGRectGetMinX(_mainViewController.view.frame)+point.x >= 0 &&
//            CGRectGetMinX(_mainViewController.view.frame)+point.x <= menuWidth) {
//        CGRect newFrame = _mainViewController.view.frame;
//        newFrame.origin.x = CGRectGetMinX(newFrame)+point.x;
//        _mainViewController.view.frame = newFrame;
//        [pan setTranslation:CGPointZero inView:_mainViewController.view];
//        }
//        if (pan.state == UIGestureRecognizerStateEnded) {
//            if (CGRectGetMinX(_mainViewController.view.frame) > menuWidth/2) {
//                [self showMemuViewController];
//            } else if (CGRectGetMinX(_mainViewController.view.frame) < 0) {
//                [self shutDownMemuViewController];
//            } else {
//                [self shutDownMemuViewController];
//            }
//        }
//
//    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - setter
- (void)setShouldPan:(BOOL)shouldPan {
    _shouldPan = shouldPan;
    if (_shouldPan) {
        [self.firstViewController.view addGestureRecognizer:self.pan];
        self.pan.delegate = self;
    } else {
        [self.firstViewController.view removeGestureRecognizer:self.pan];
    }
}

- (void)setShouldSwipe:(BOOL)shouldSwipe {
    _shouldSwipe = shouldSwipe;
    if (_shouldSwipe) {
        [self.rootViewController.view addGestureRecognizer:self.rightSwipe];
        [self.rootViewController.view addGestureRecognizer:self.leftSwipe];
        
        self.rightSwipe.delegate = self;
        self.leftSwipe.delegate = self;
    } else {
        
        [self.rootViewController.view removeGestureRecognizer:self.rightSwipe];
        [self.rootViewController.view removeGestureRecognizer:self.leftSwipe];
    }
}

- (void)setShouldTapToShutDown:(BOOL)shouldTapToShutDown{
    _shouldTapToShutDown = shouldTapToShutDown;
    if (_shouldTapToShutDown) {
        [self.firstViewController.view addGestureRecognizer:self.tap];
    } else {
        [self.firstViewController.view removeGestureRecognizer:self.tap];
    }
}

#pragma mark - getter
- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shutDownMemuViewController)];
    }
    return _tap;
}

- (UIPanGestureRecognizer *)pan {
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    }
    return _pan;
}

- (UISwipeGestureRecognizer *)rightSwipe {
    if (!_rightSwipe) {
        _rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMemuViewController)];
        _rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    }
    return _rightSwipe;
}

- (UISwipeGestureRecognizer *)leftSwipe {
    if (!_leftSwipe) {
        _leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(shutDownMemuViewController)];
        _leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    return _leftSwipe;
}

- (UIViewController *)firstViewController {
    if (!_firstViewController) {
        if (_mainViewController && [_mainViewController isKindOfClass:[UIViewController class]]) {
            if ([_mainViewController isKindOfClass:[UINavigationController class]]) {
                
                _firstViewController = ((UINavigationController *)_mainViewController).viewControllers[0];
            } else if ([_mainViewController isKindOfClass:[UITabBarController class]]) {
                
                id temp = ((UITabBarController *)_mainViewController).viewControllers[0];
                if ([temp isKindOfClass:[UINavigationController class]]) {
                    
                    _firstViewController = ((UINavigationController *)temp).viewControllers[0];
                } else {
                    
                    _firstViewController = temp;
                }
            } else {
                _firstViewController = _mainViewController;
            }
        }
    }
    return _firstViewController;
}


@end
