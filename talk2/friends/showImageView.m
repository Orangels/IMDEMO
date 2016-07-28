//
//  showImageView.m
//  talk2
//
//  Created by 刘森 on 16/6/1.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "showImageView.h"
#import "AppDelegate.h"
@implementation showImageView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self becomeFirstResponder];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1:)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tap2:)];
        [self addGestureRecognizer:longPress];
        
        [singleTap requireGestureRecognizerToFail:longPress];
        
    }
    return self;
}

-(IBAction)tap1:(UITapGestureRecognizer*)tap{
    UIMenuController* menuVc = [UIMenuController sharedMenuController];
    [menuVc setMenuVisible:NO animated:YES];
}

-(IBAction)tap2:(UILongPressGestureRecognizer*)tap{
    if (tap.state == UIGestureRecognizerStateBegan) {
        UIMenuController* menuVc = [UIMenuController sharedMenuController];
        UIMenuItem* item1 = [[UIMenuItem alloc] initWithTitle:@"保存图片" action:@selector(downloadImage:)];
        menuVc.menuItems = @[item1];
        if (menuVc.isMenuVisible) {
            [menuVc setMenuVisible:NO animated:YES];
        }
        CGPoint point = [tap locationInView:self];
        CGRect rect = CGRectMake(point.x, point.y, 0, 0);
        [menuVc setTargetRect:rect inView:self];
        [menuVc setMenuVisible:YES animated:YES];
    }

    
}

- (void)downloadImage:(UIMenuController*)menu{
    UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    [app.window.rootViewController presentViewController:alert animated:YES completion:nil];
    [self performSelector:@selector(dismiss:) withObject:alert afterDelay:1];
}
- (void)dismiss:(UIAlertController*)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)canBecomeFirstResponder{
    return YES;
}


@end
