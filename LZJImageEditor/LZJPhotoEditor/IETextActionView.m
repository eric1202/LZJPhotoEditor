//
//  IETextActionView.m
//  LZJImageEditor
//
//  Created by weima on 2019/4/16.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IETextActionView.h"
#import <Masonry.h>
@interface IETextActionView()
@property (nonatomic, strong) UIView *bottomView;//颜色按钮容器
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, copy) NSArray *colors;
@end

@implementation IETextActionView

- (instancetype)init
{
    if (self = [super init]) {
        [self configureView];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configureView];
        
    }
    return self;
}

#pragma mark -
#pragma mark - configure

- (void)configureView
{
    self.colors = @[[UIColor whiteColor],[UIColor blackColor],[UIColor redColor],[UIColor yellowColor],[UIColor greenColor],[UIColor blueColor],[UIColor purpleColor]];
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(140);
    }];
    
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_top).offset(130);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.height.mas_equalTo(48);
        make.width.mas_equalTo(70);
    }];
    
    [self addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_top).offset(130);
        make.right.mas_equalTo(self.mas_right).offset(6);
        make.height.mas_equalTo(48);
        make.width.mas_equalTo(60);
    }];
    

    
    
}

#pragma mark - Private

-(void)showTextView{
    if(!self.contentTextView.superview){
        [self insertSubview:self.contentTextView belowSubview:self.bottomView];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.contentTextView becomeFirstResponder];
        });
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    CGSize size = [self sizeWithString:[NSString stringWithFormat:@"%@\n",textView.text] font:textView.font width:CGRectGetWidth(textView.frame)];
    
    if (size.height <= 200) {
        CGRect frame = textView.frame;
        frame.size.height = size.height + (10);
        textView.frame = frame;
        textView.center = CGPointMake((187.5), (180));
    }else{
        CGRect frame = _contentTextView.frame;
        frame.size.height = (210);
        _contentTextView.frame = frame;
        _contentTextView.center = CGPointMake((187.5), (180));
    }
    
    NSLog(@"StoryMake.ContentTexViewHeight : %f",size.height);
}

-(CGSize)sizeWithString:(NSString*)string font:(UIFont*)font width:(float)width
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 80000)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil];
    return rect.size;
}

#pragma mark -
#pragma mark - Getter

- (UIButton *)cancelBtn {
    if(!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if(!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitle:@"Done" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:UIColor.orangeColor forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _confirmBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        
        /** add colors **/
        [self.colors enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            btn.tag = idx +1000;
            [btn addTarget:self action:@selector(changeColor:) forControlEvents:(UIControlEventTouchUpInside)];
            [btn setBackgroundColor:color];
            
            btn.layer.borderColor = UIColor.whiteColor.CGColor;
            btn.layer.borderWidth = 4;
            btn.layer.cornerRadius = 15;
            [_bottomView addSubview:btn];
        }];
        
        [_bottomView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:30 leadSpacing:10 tailSpacing:10];
        [_bottomView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_bottomView);
            make.height.mas_equalTo(30);
        }];
    }
    return _bottomView;
}

- (UITextView *)contentTextView{
    if (!_contentTextView) {
        
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.font = [UIFont systemFontOfSize:16];
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.textColor = UIColor.whiteColor;
        _contentTextView.tintColor = UIColor.whiteColor;
        _contentTextView.delegate = self;
        _contentTextView.textAlignment = NSTextAlignmentCenter;
        _contentTextView.frame = CGRectMake(0, 0, 340, 30);
        _contentTextView.center = CGPointMake(CGRectGetWidth(self.frame)/2, 180);

    }
    return _contentTextView;
}


#pragma mark -
#pragma mark - Btn action
- (void)changeColor:(UIButton *)btn{
    if(self.contentTextView){
        self.contentTextView.textColor = self.colors[btn.tag -1000];
    }
    [self showTextView];
}

- (void)cancelBtnAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ieTextActionCloseBtnClicked)]) {
        [self.delegate ieTextActionCloseBtnClicked];
        [_contentTextView removeFromSuperview];
        _contentTextView = nil;
        [self removeFromSuperview];

    }
}

- (void)confirmBtnAction
{
    
    if (_contentTextView.text.length<1) {
        [self cancelBtnAction];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ieTextActionConfirmBtnClicked:font:color:)]) {
        [self.delegate ieTextActionConfirmBtnClicked:_contentTextView.text font:_contentTextView.font color:_contentTextView.textColor];
        [_contentTextView removeFromSuperview];
        _contentTextView = nil;
        [self removeFromSuperview];
    }
    
}
@end
