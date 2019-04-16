//
//  IEViewController.m
//  LZJImageEditor
//
//  Created by weima on 2019/4/12.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "IEViewController.h"
#import "IEManager.h"
#import "IEToolBar.h"
#import "IEImageView.h"
#import "IETextStickerView.h"
#import "IETextActionView.h"
@interface IEViewController ()<IeTextActionDelegate>
@property (nonatomic, strong) IEImageView *originImageView;
@property (nonatomic, strong) IEImageView *resultImageView;
@property (nonatomic, strong) IEToolBar *toolBar;
@property (nonatomic, strong) IEManager *imageEditManager;

@property (nonatomic, strong) NSMutableArray *stickerViewArray;
@property (nonatomic, assign) NSInteger stickerTag;
@end

@implementation IEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑图片";
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.resultImageView];
    [self.view addSubview:self.toolBar];

    self.originImageView.image = self.image;
    self.resultImageView.image = self.image;
    
    self.stickerViewArray = @[].mutableCopy;
}

#pragma mark - Delegate
- (void)ieTextActionCloseBtnClicked{
    self.toolBar.hidden = NO;

}

- (void)ieTextActionConfirmBtnClicked:(NSString *)text font:(UIFont *)font color:(UIColor *)color{

    self.toolBar.hidden = NO;
    
    CGRect rect1 = [text boundingRectWithSize:CGSizeMake(340, MAXFLOAT)
                                      options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    CGRect rect2 = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 100)
                                      options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    
    if (rect2.size.width > 340) {
        rect2.size.width = 340;
    }
    
    IETextStickerView *stickeLabelView = [[IETextStickerView alloc] initWithLabelHeight:CGSizeMake(rect2.size.width, rect1.size.height)];
    stickeLabelView.delegate = self;
    stickeLabelView.tag = self.stickerTag++;
    stickeLabelView.frame = CGRectMake(0, 0, rect2.size.width + 44, rect1.size.height + 34);
    stickeLabelView.center = CGPointMake(self.view.frame.size.width/2, 180);
    stickeLabelView.contentLabel.text = text;
    stickeLabelView.contentLabel.font = font;
    stickeLabelView.contentLabel.textColor = color;
    
    [self.resultImageView addSubview:stickeLabelView];
    
    [self.stickerViewArray insertObject:stickeLabelView atIndex:0];
}
#pragma mark - Custom Methods

#pragma mark - Set & Get
-(IEImageView *)resultImageView{
    if (!_resultImageView) {
        _resultImageView = [[IEImageView alloc]initWithFrame:self.view.bounds];
        _resultImageView.contentMode = UIViewContentModeScaleAspectFit;
        _resultImageView.backgroundColor = UIColor.blackColor;
    }
    
    return _resultImageView;
}

-(IEImageView *)originImageView{
    if (!_originImageView) {
        _originImageView = [[IEImageView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame))];
        //        _resultImageView.contentMode = UIViewContentModeScaleAspectFit;
        _originImageView.backgroundColor = UIColor.blackColor;
    }
    
    return _originImageView;
}

-(IEToolBar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[IEToolBar alloc]initWithOptions:self.imageEditManager.options];
        
        _toolBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-100, CGRectGetWidth(self.view.frame), 100);
        
    }
    
    return _toolBar;
}

- (IEManager *)imageEditManager{
    if (!_imageEditManager) {
        _imageEditManager = [[IEManager alloc]init];
    }
    
    return _imageEditManager;
}
#pragma mark - Notification

#pragma mark - Event Response

@end
