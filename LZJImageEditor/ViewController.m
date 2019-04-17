//
//  ViewController.m
//  LZJImageEditor
//
//  Created by weima on 2019/4/12.
//  Copyright © 2019年 weima. All rights reserved.
//

#import "ViewController.h"
#import "IEViewController.h"
@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)selectImage:(id)sender {
    UIImagePickerController *vc = [[UIImagePickerController alloc]init];
    vc.allowsEditing = NO;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    NSLog(@"%@",info);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        IEViewController *vc = [[IEViewController alloc]init];
        vc.image = info[@"UIImagePickerControllerOriginalImage"];
        [vc setCompleteBlock:^(UIImage * _Nonnull image) {
            _imageView.image = image;
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
