//
//  SlidingMenuManger.h
//  SlidingOfQQDemo
//
//  Created by B.Dog on 16/3/3.
//  Copyright © 2016年 JKSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,SlidingMenuState) {
    SlidingMenuStateClose = 0,
    SlidingMenuStateOpen,
    SlidingMenuStateClosing,
    SlidingMenuStateOpening
};

typedef NS_ENUM(NSInteger, SlidingType) {
    SlidingTypeFromLeft = 0,
    SlidingTypeFromLeftScale,
    SlidingTypeFromTop,
    SlidingTypeFromRight,
    SlidingTypeFromBottom
};


@interface SlidingMenuManger : NSObject

@property (nonatomic, assign) BOOL isMenuShowing;
@property (nonatomic, assign) BOOL shouldPan;
@property (nonatomic, assign) BOOL shouldSwipe;
@property (nonatomic, assign) BOOL shouldTapToShutDown;
//@property (nonatomic, assign) BOOL shouldScale;
@property (nonatomic, assign) SlidingType slidingType;



+ (instancetype)manager;

- (void)startWithMainViewController:(UIViewController *)mainViewController
                 menuViewController:(UIViewController *)menuViewController
                        slidingType:(SlidingType)slidingType;

- (void)pressTheSwitchOfMenu;
- (void)shutDownMemuViewController;
- (void)showMemuViewController;

@end
