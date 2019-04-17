//
//  IEToolBar.m
//  LZJImageEditor
//
//  Created by weima on 2019/4/12.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IEToolBar.h"
#import "IEHelper.h"
#import "IEPinActionSheetView.h"
#import "IEEffectActionSheetView.h"

#import "IETextActionView.h"

@interface IEToolBar()
@property (nonatomic, copy) NSArray *options;
@end

@implementation IEToolBar

- (IEToolBar *)initWithOptions:(NSArray *)array{
    self = [super initWithFrame:CGRectMake(0, 0, [IEHelper findViewController].view.frame.size.width, 100)];
    self.backgroundColor = UIColor.whiteColor;
    self.options = array;
    
    [self addBtns];
    
    return self;
}

- (void)addBtns{
    CGFloat width = self.frame.size.width/self.options.count;
    [self.options enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = [IEHelper findViewController];

        UIView *view = [self viewWithTitle:obj[@"title"] ImageOrUrl:obj[@"image"] Click:^{
            NSLog(@"%@",obj[@"title"]);
            if(idx == 0){
                IEConfig *config = [[IEConfig alloc]init];
                config.title = @"贴图";
                config.datas = @[@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"},@{@"image":@"ma",@"title":@"贴图"}];
                
                IEPinActionSheetView *view = [[IEPinActionSheetView alloc]initWithConfig:config];
                view.delegate = vc;
                [vc.view addSubview:view];
                
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.bottom.right.mas_equalTo(0);
                    make.height.mas_equalTo(CGRectGetHeight(vc.view.frame)*0.38);

                }];
//                [vc.view layoutIfNeeded];
//
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [UIView animateWithDuration:0.33 animations:^{
//                        [view mas_updateConstraints:^(MASConstraintMaker *make) {
//                            make.height.mas_equalTo(CGRectGetHeight(vc.view.frame)*0.38);
//                        }];
//
//                        [vc.view layoutIfNeeded];
//                    }];
//                });
                

                self.hidden = YES;
                
            }
            else if (idx == 2) {
                IEConfig *config = [[IEConfig alloc]init];
                config.title = @"马赛克";
                config.datas = @[@{@"image":@"mosaic",@"title":@"马赛克"},@{@"image":@"gaosi",@"title":@"模糊"},@{@"image":@"redo",@"title":@"还原"}];
                config.itemInlineCount = 3;
                
                IEEffectActionSheetView *view = [[IEEffectActionSheetView alloc]initWithConfig:config];
                view.delegate = vc;
                [vc.view addSubview:view];
                
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.bottom.right.mas_equalTo(0);
                    make.height.mas_equalTo(140);
                }];
            }
            else if (idx == 3) {
                IETextActionView *view = [[IETextActionView alloc]initWithFrame:vc.view.bounds];
                view.delegate = vc;
                [vc.view addSubview:view];
                [view showTextView];
                self.hidden = YES;
            }
        }];
        
        view.frame = CGRectMake(width*idx, 0, width, 100);
        
        [self addSubview:view];
    }];
}

- (UIView *)viewWithTitle:(NSString *)title ImageOrUrl:(NSString *)imageOrUrl Click:(void(^)(void))block{
    UIView *view1 = [[UIView alloc] init];
    UILabel *lb1 = [self labelWithText:title];
    UIImageView *iv1 = [self imageViewWithName:imageOrUrl];
    [view1 addSubview:iv1];
    [view1 addSubview:lb1];
    
    view1.userInteractionEnabled = YES;
    
    [view1 addGestureRecognizer:[UITapGestureRecognizer nvm_gestureRecognizerWithActionBlock:^{
        block();
    }]];

    [iv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view1);
        make.top.mas_equalTo(10);
        make.width.height.mas_equalTo(50);
    }];

    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(iv1.mas_bottom).offset(10);
    }];
    
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
