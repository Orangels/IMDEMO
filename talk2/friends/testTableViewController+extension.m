//
//  testTableViewController+extension.m
//  talk2
//
//  Created by 刘森 on 16/5/31.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "testTableViewController+extension.h"
#import "testTableViewController+sendSound.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@implementation testTableViewController (extension)
- (void)creatLsPopView{
    CGPoint point    = CGPointMake(WITH-30, self.enterView.frame.origin.y-5);
    NSArray* titleArr = @[@"图片",@"拍摄",@"视频"];
    //上下各留5
    NSInteger height = 40;
    CGFloat with = (WITH-20)/titleArr.count;
    self.lsPopView = [[lsView alloc] initWithOrigin:point Width:WITH-20 Height:height Direction:lsArrowDirectionDown3];
    for (int i = 0; i<titleArr.count; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(10+i*with, 5, with-10, 30);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(extensionClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.lsPopView.backView addSubview:btn];
    }
    
    
}
- (IBAction)extensionClick:(UIButton*)btn{
    if ([btn.titleLabel.text isEqualToString:@"图片"]) {
        UIImagePickerController* picker = [UIImagePickerController new];
        picker.delegate = self;
        picker.allowsEditing = YES;
        //图片来源
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //这里不做 iphone 和 ipad 的判断
        [self presentViewController:picker animated:YES completion:nil];
    }
    if ([btn.titleLabel.text isEqualToString:@"拍摄"]) {
        UIImagePickerController* picker = [UIImagePickerController new];
        picker.delegate      = self;
        picker.allowsEditing = YES;
        picker.sourceType    = UIImagePickerControllerSourceTypeCamera;//调用照相机
        [self presentViewController:picker animated:YES completion:nil];
    }
    if ([btn.titleLabel.text isEqualToString:@"视频"]) {
        //设置拍摄视频
        [self imagePickerControllerOptions];
        
    }
    if ([btn.titleLabel.text isEqualToString:@"位置"]) {
        NSLog(@"位置");
    }
    
}

- (void)imagePickerControllerOptions{
    //检测网络状态
    self.reach            = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    //开始检测,界面消失时要结束检测

#if 1
    UIImagePickerController* picker = [UIImagePickerController new];
    picker.sourceType               = UIImagePickerControllerSourceTypeCamera;
    //后置摄像头
    picker.cameraDevice             = UIImagePickerControllerCameraDeviceRear;
    picker.mediaTypes               = @[(NSString *)kUTTypeMovie];
    picker.cameraCaptureMode        = UIImagePickerControllerCameraCaptureModeVideo;
    picker.allowsEditing = NO;
    picker.delegate                 = self;
#endif

    [self.reach startNotifier];
    switch ([self.reach currentReachabilityStatus]) {
        case NotReachable:{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前无网络" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action    = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        case ReachableViaWiFi:
                //wifi,设置视频格式, wan 中等质量
            picker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
            break;
        case ReachableViaWWAN:
            picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
            break;
        default:
            break;
    }
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //发送图片消息
    //获得编辑后的图片
    
#warning 判断图片还是视频
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];

    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        //视频
        NSURL *url = info[UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr = [url path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {//判断是否可以保存
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
        }
        
        EMChatVideo *videoChat = [[EMChatVideo alloc] initWithFile:urlStr displayName:[NSString stringWithFormat:@"video%@",[self getTimeStr]]];
        EMVideoMessageBody* body = [[EMVideoMessageBody alloc] initWithChatObject:videoChat];
        EMMessage *message = [[EMMessage alloc] initWithReceiver:self.buddyName bodies:@[body]];
        if (self.isBuddy) {
            //单聊
            message.messageType = eMessageTypeChat;
        }else{
            //群聊
            message.messageType = eConversationTypeGroupChat;
        }
        //加载时显示动画
        UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.hidesWhenStopped         = YES;
        [picker.view addSubview:activityView];
        activityView.center = picker.view.center;
        [activityView startAnimating];
        
        [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:nil onQueue:nil completion:^(EMMessage *message, EMError *error) {
            [activityView stopAnimating];
            if (!error) {
                NSLog(@"发送成功");
                //添加到数组,省去重新读取 conversation 的步骤
                [self.messageArr addObject:message];
                //插入 cell 并滑动到最后一行
                NSIndexPath *index = [NSIndexPath indexPathForRow:self.messageArr.count-1 inSection:0];
                [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else{
                NSLog(@"%@",error);
            }
        } onQueue:nil];
        
    }else{
        //图片
        //加载动画
        UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.hidesWhenStopped         = YES;
        [picker.view addSubview:activityView];
        activityView.center = picker.view.center;
        [activityView startAnimating];
        
        UIImage* image = info[UIImagePickerControllerOriginalImage];
        NSString* timer = [self getTimeStr];
        EMChatImage *imgChat = [[EMChatImage alloc] initWithUIImage:image displayName:[NSString stringWithFormat:@"image%@",timer]];
        EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithChatObject:imgChat];
        EMMessage *message = [[EMMessage alloc] initWithReceiver:self.buddyName bodies:@[body]];
        if (self.isBuddy) {
            //单聊
            message.messageType = eMessageTypeChat;
        }else{
            //群聊
            message.messageType = eConversationTypeGroupChat;
        }
        //发送消息并滚动到最后一行
        [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:nil onQueue:nil completion:^(EMMessage *message, EMError *error) {
            [activityView stopAnimating];
            if (!error) {
                NSLog(@"发送成功");
                //添加到数组,省去重新读取 conversation 的步骤
                [self.messageArr addObject:message];
                //插入 cell 并滑动到最后一行
                NSIndexPath *index = [NSIndexPath indexPathForRow:self.messageArr.count-1 inSection:0];
                [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        } onQueue:nil];
    }
}
//保存视频后回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"保存成功");
}














@end
