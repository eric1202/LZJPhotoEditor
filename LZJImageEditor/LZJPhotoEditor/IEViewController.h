//
//  IEViewController.h
//  LZJImageEditor
//
//  Created by weima on 2019/4/12.
//  Copyright © 2019年 weima. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IEViewController : UIViewController
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) void(^completeBlock)(UIImage *image);
@end

NS_ASSUME_NONNULL_END
