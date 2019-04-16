//
//  IETextActionView.h
//  LZJImageEditor
//
//  Created by weima on 2019/4/16.
//  Copyright © 2019年 weima. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IeTextActionDelegate <NSObject>

@optional
- (void)ieTextActionCloseBtnClicked;
- (void)ieTextActionConfirmBtnClicked:(NSString *)text font:(UIFont *)font color:(UIColor *)color;

@end

@interface IETextActionView : UIView

-(void)showTextView;

@property (nonatomic, weak) id <IeTextActionDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
