//
//  IEToolBar.m
//  LZJImageEditor
//
//  Created by weima on 2019/4/12.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IEToolBar.h"

@interface IEToolBar()
@property (nonatomic, copy) NSArray *options;
@end

@implementation IEToolBar

- (IEToolBar *)initWithOptions:(NSArray *)array{
    self = [super initWithFrame:CGRectMake(0, 0, 375, 100)];
    
    self.options = array;
    
    [self addBtns];
    
    return self;
}

- (void)addBtns{
    CGFloat width = 375.0/self.options.count;
    [self.options enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = [self viewWithTitle:obj[@"title"] ImageOrUrl:obj[@"image"] Click:^{
        }];
        
        view.frame = CGRectMake(width*idx, 0, width, 100);
        
        [self addSubview:view];
    }];
}

- (UIView *)viewWithTitle:(NSString *)title ImageOrUrl:(NSString *)imageOrUrl Click:(void(^)())block{
    UIView *view1 = [[UIView alloc] init];
    UILabel *lb1 = [self labelWithText:title];
    UIImageView *iv1 = [self imageViewWithName:imageOrUrl];
    [view1 addSubview:iv1];
    [view1 addSubview:lb1];
    
    view1.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    
//    [[tap rac_gestureSignal] subscribeNext:^(id x) {
//        block();
//    }];
    
    [view1 addGestureRecognizer:tap];
    
//    [iv1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(view1);
//        make.top.mas_equalTo(10);
//        make.width.height.mas_equalTo(50);
//    }];
//
//    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.top.mas_equalTo(iv1.mas_bottom).offset(10);
//    }];
    
    return view1;
}

- (UIImageView *)imageViewWithName:(NSString *)name {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:name];
    
    return imageView;
}

- (UILabel *)labelWithText:(NSString *)string {
    UILabel *label = [[UILabel alloc] init];
    
    label.text = string;
    label.textColor = UIColor.blackColor;
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

@end
