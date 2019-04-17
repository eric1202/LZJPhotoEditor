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
#import "IEPinActionSheetView.h"
#import "IEEffectActionSheetView.h"
#import "IEHelper.h"
#import "IEMosaicView.h"
#import "IEPinStickerView.h"

#define NaviPosY 64
#define BottomH 140
#define ToolBarH 100
@interface IEViewController ()<IeTextActionDelegate, IEActionSheetViewDelegate>
@property (nonatomic, strong) IEImageView *originImageView;
@property (nonatomic, strong) IEImageView *resultImageView;
@property (nonatomic, strong) IEToolBar *toolBar;
@property (nonatomic, strong) IEManager *imageEditManager;
@property (nonatomic, strong) IEMosaicView *currentMosaicView;
@property (nonatomic, strong) NSMutableArray *stickerViewArray;
@property (nonatomic, assign) NSInteger stickerTag;
@end

@implementation IEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑图片";
    self.view.backgroundColor = UIColor.blackColor;
    
    [self.view addSubview:self.resultImageView];
    [self.view addSubview:self.toolBar];
    
    self.originImageView.image = self.image;
    self.resultImageView.image = self.image;
    
    CGFloat ScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat ScreenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat imageSizeWidth = self.image.size.width;
    CGFloat imageSizeHeight = self.image.size.height;
    CGFloat scale = ScreenWidth * imageSizeHeight / imageSizeWidth;
    
    self.resultImageView.frame = CGRectMake(0, (ScreenHeight-NaviPosY-scale)/2, ScreenWidth, scale);
    
    self.stickerViewArray = @[].mutableCopy;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(save:)];
}

#pragma mark - Delegate

- (void)didSelectAtIndex:(NSInteger)index ActionView:(IEActionSheetView *)view Image:(UIImage *)image{
    if([view isKindOfClass:IEPinActionSheetView.class]){
        IEPinStickerView *stickerImageView = [[IEPinStickerView alloc]init];
        
        stickerImageView.delegate = self;
        stickerImageView.tag = self.stickerTag ++;
        stickerImageView.frame = CGRectMake(0, 0, 128, 128);
        stickerImageView.center = CGPointMake(self.resultImageView.center.x, self.resultImageView.frame.size.height/2);
        stickerImageView.contentImageView.image = image;
        [self.resultImageView addSubview:stickerImageView];
        
        [self.stickerViewArray insertObject:stickerImageView atIndex:0];
    }
    else if([view isKindOfClass:IEEffectActionSheetView.class]){
        //begin mosaic
        NSLog(@"mosaic image begin");
        if(index != 2){
            
            IEMosaicView *mv = [[IEMosaicView alloc]initWithFrame:self.resultImageView.bounds];
            
            mv.contentMode = UIViewContentModeScaleAspectFit;
            mv.originalImage = _currentMosaicView?[_currentMosaicView render]:self.originImageView.image;
            
            [self.resultImageView addSubview:mv];
            
            if(_currentMosaicView){
                [_currentMosaicView removeFromSuperview];
                _currentMosaicView = nil;
            }
            _currentMosaicView = mv;
            _currentMosaicView.mosaicImage = [IEMosaicView mosaicImage:self.resultImageView.image mosaicLevel:20*(index+1)];
            //change brush style
            
        }
        else{
            if(_currentMosaicView && _currentMosaicView.canUndo){
                [_currentMosaicView undo];
            }
        }
    }
    
}

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
    
    IETextStickerView *textStickerView = [[IETextStickerView alloc] initWithLabelHeight:CGSizeMake(rect2.size.width, rect1.size.height)];
    textStickerView.delegate = self;
    textStickerView.tag = self.stickerTag++;
    textStickerView.frame = CGRectMake(0, 0, rect2.size.width + 44, rect1.size.height + 34);
    textStickerView.center = CGPointMake(self.resultImageView.center.x, self.resultImageView.frame.size.height/2);
    textStickerView.contentLabel.text = text;
    textStickerView.contentLabel.font = font;
    textStickerView.contentLabel.textColor = color;
    
    [self.resultImageView addSubview:textStickerView];
    
    [self.stickerViewArray insertObject:textStickerView atIndex:0];
}
#pragma mark - Custom Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.resultImageView];
    BOOL selected = NO;
    
    for (UIView *obj in self.stickerViewArray) {
        if ([obj isKindOfClass:[IEStickerBaseView class]]) {
            IEStickerBaseView *view = (IEStickerBaseView *)obj;
            if (CGRectContainsPoint(view.frame, point) && !selected) {
                view.isSelected = YES;
                selected = YES;
            }else{
                view.isSelected = NO;
            }
        }
    }
}

- (void)save:(id)sender{
    if(_completeBlock){
        _completeBlock([self.resultImageView outputImage]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Set & Get
-(IEImageView *)resultImageView{
    if (!_resultImageView) {
        
        _resultImageView = [[IEImageView alloc]initWithFrame:CGRectZero];
        _resultImageView.contentMode = UIViewContentModeScaleAspectFit;
        _resultImageView.backgroundColor = UIColor.blackColor;
        _resultImageView.center = self.view.center;
        __weak IEViewController *weakSelf = self;
        [_resultImageView addGestureRecognizer:[UITapGestureRecognizer nvm_gestureRecognizerWithActionBlock:^{
            for (UIView *v in weakSelf.view.subviews) {
                if ([v isKindOfClass:IEActionSheetView.class] || [v isKindOfClass:IETextActionView.class]) {
                    [v removeFromSuperview];
                }
                
            }
            weakSelf.toolBar.hidden = !weakSelf.toolBar.hidden;
        }]];
    }
    
    return _resultImageView;
}

-(IEImageView *)originImageView{
    if (!_originImageView) {
        _originImageView = [[IEImageView alloc]initWithFrame:CGRectZero];
        _originImageView.contentMode = UIViewContentModeScaleAspectFit;
        _originImageView.center = self.view.center;
        _originImageView.backgroundColor = UIColor.blackColor;
    }
    
    return _originImageView;
}

-(IEToolBar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[IEToolBar alloc]initWithOptions:self.imageEditManager.options];
        
        _toolBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-ToolBarH, CGRectGetWidth(self.view.frame), ToolBarH);
        
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
