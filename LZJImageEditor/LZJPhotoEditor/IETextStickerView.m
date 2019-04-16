//
//  IETextStickerView.m
//  LZJImageEditor
//
//  Created by weima on 2019/4/16.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IETextStickerView.h"

@interface IETextStickerView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *seperatoeView;

@property (nonatomic, assign) CGSize labelSize;

@end

@implementation IETextStickerView

- (instancetype)initWithLabelHeight:(CGSize)labelSize
{
    self = [super init];
    if (self) {
        self.labelSize = labelSize;
    }
    return self;
}

- (void)layoutSubviews
{
    self.seperatoeView.frame = CGRectMake(0, 0, self.labelSize.width + 20, self.labelSize.height + 10);
    self.seperatoeView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    [self addSubview:self.seperatoeView];
    
    self.contentLabel.frame = CGRectMake(0, 0, self.labelSize.width, self.labelSize.height);
    self.contentLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    [self addSubview:self.contentLabel];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImage:)];
    pinchGesture.delegate = self;
    [self addGestureRecognizer:pinchGesture];
    
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateImage:)];
    rotationGesture.delegate = self;
    [self addGestureRecognizer:rotationGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)];
    [self addGestureRecognizer:panGesture];
    
    [super layoutSubviews];
}

#pragma mark -
#pragma mark - Private method

-(void)pinchImage:(UIPinchGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        self.transform = CGAffineTransformScale(self.transform, gesture.scale, gesture.scale);
        gesture.scale = 1;
    }
}

-(void)rotateImage:(UIRotationGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        self.transform = CGAffineTransformRotate(self.transform, gesture.rotation);
        [gesture setRotation:0];
    }
}

- (void)panImage:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self.superview];
        [self setCenter:(CGPoint){self.center.x + translation.x, self.center.y + translation.y}];
        [gesture setTranslation:CGPointZero inView:self.superview];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark -
#pragma mark - Private method

- (void)setIsSelected:(BOOL)isSelected
{
    [super setIsSelected:isSelected];
    if (isSelected) {
        self.seperatoeView.layer.borderColor = [UIColor colorWithWhite:1 alpha:.5].CGColor;
        self.seperatoeView.layer.borderWidth = 2;
    }else{
        self.seperatoeView.layer.borderWidth = 0;
    }
}

//
- (void)adjustSizeOfSelect:(CGFloat)scale
{
    [super adjustSizeOfSelect:scale];
    
    self.seperatoeView.layer.borderColor = [UIColor colorWithWhite:1 alpha:.5].CGColor;
    self.seperatoeView.layer.borderWidth = 2;
}

#pragma mark -
#pragma mark - Getter

- (UIView *)seperatoeView
{
    if (!_seperatoeView) {
        _seperatoeView = [[UIView alloc] init];
        _seperatoeView.layer.borderColor = [UIColor colorWithWhite:1 alpha:.5].CGColor;
        _seperatoeView.layer.borderWidth = 2;
    }
    return _seperatoeView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _contentLabel;
}

@end

