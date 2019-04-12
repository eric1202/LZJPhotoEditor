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

@interface IEViewController ()
@property (nonatomic, strong) UIImageView *originImageView;
@property (nonatomic, strong) UIImageView *resultImageView;
@property (nonatomic, strong) IEToolBar *toolBar;
@property (nonatomic, strong) IEManager *imageEditManager;
@end

@implementation IEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑图片";
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.resultImageView];
    [self.view addSubview:self.toolBar];

    self.resultImageView.image = self.image;
    
}

#pragma mark - Delegate

#pragma mark - Custom Methods

#pragma mark - Set & Get
-(UIImageView *)resultImageView{
    if (!_resultImageView) {
        _resultImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame))];
//        _resultImageView.contentMode = UIViewContentModeScaleAspectFit;
        _resultImageView.backgroundColor = UIColor.blueColor;
    }
    
    return _resultImageView;
}

-(IEToolBar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[IEToolBar alloc]initWithOptions:self.imageEditManager.options];
        
        _toolBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-100, CGRectGetWidth(self.view.frame), 100);
        
        _toolBar.backgroundColor = UIColor.blueColor;
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
