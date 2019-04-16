//
//  IEHelper.m
//  LZJImageEditor
//
//  Created by weima on 2019/4/15.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IEHelper.h"
#import <objc/runtime.h>
@implementation IEHelper
+ (UIViewController *)findViewController{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    UIViewController* rootViewController = window.rootViewController;
    return [self currentViewControllerFrom:rootViewController];
}

+ (UIViewController*)currentViewControllerFrom:(UIViewController*)viewController {
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController* navigationController = (UINavigationController *)viewController;
        return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
        
    } else if([viewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController* tabBarController = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
        
    } else if(viewController.presentedViewController != nil) {
        
        return [self currentViewControllerFrom:viewController.presentedViewController];
        
    } else {
        
        return viewController;
        
    }
}
@end


@implementation UIButton (UIBlockButton)

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block {
    objc_setAssociatedObject(self, &UIButtonBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}


- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &UIButtonBlockKey);
    if (block) {
        block();
    }
}


@end


@implementation UITapGestureRecognizer(TapBlock)

static const int target_key;

+(instancetype)nvm_gestureRecognizerWithActionBlock:(ActionBlock)block {
    return [[self alloc]initWithActionBlock:block];
}

- (instancetype)initWithActionBlock:(ActionBlock)block {
    self = [self init];
    [self addActionBlock:block];
    [self addTarget:self action:@selector(invoke:)];
    return self;
}

- (void)addActionBlock:(ActionBlock)block {
    if (block) {
        objc_setAssociatedObject(self, &target_key, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (void)invoke:(id)sender {
    ActionBlock block = objc_getAssociatedObject(self, &target_key);
    if (block) {
        block();
    }
}
@end
