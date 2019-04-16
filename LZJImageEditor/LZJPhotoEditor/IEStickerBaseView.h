
#import <UIKit/UIKit.h>

@class IEStickerBaseView;

@protocol IEStickerBaseViewDelegate <NSObject>

@optional
- (void)stickerBaseViewCloseBtnClicked:(IEStickerBaseView *)view;

@end


@interface IEStickerBaseView : UIView

@property (nonatomic, weak) id <IEStickerBaseViewDelegate> delegate;

@property (nonatomic, assign) BOOL isSelected;

- (void)adjustSizeOfSelect:(CGFloat)scale;

@end
