//
//  IEHelper.h
//  LZJImageEditor
//
//  Created by weima on 2019/4/15.
//  Copyright © 2019年 weima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Masonry.h>


typedef void(^ActionBlock)(void);
static char UIButtonBlockKey;


NS_ASSUME_NONNULL_BEGIN

@interface IEHelper : NSObject
+ (UIViewController *)findViewController;
@end

NS_ASSUME_NONNULL_END

@interface UIButton (UIBlockButton)

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block;
- (void)callActionBlock:(id)sender;

@end

@interface UITapGestureRecognizer (TapBlock)

+(instancetype)nvm_gestureRecognizerWithActionBlock:(ActionBlock)block;
@end



