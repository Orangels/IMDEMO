//
//  testTableViewController+sendSound.m
//  talk2
//
//  Created by 刘森 on 16/5/30.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "testTableViewController+sendSound.h"

@implementation testTableViewController (sendSound)


#pragma mark -- 录音/发送
// 录音/发送录音
- (IBAction)sendSound:(UIButton*)btn{
    self.soundPath = [self getTimeStr];
    
    NSLog(@"%@",self.soundPath);
    btn.selected ^= 1;
    
    if (btn.selected) {
        [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:self.soundPath completion:^(NSError *error)
         {
             if (error) {
                 NSLog(@"%@",NSEaseLocalizedString(@"message.startRecordFail", @"failure to start recording"));
             }else{
                 NSLog(@"开始录音");
             }
         }];
    }else {
        //加载动画
        UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.hidesWhenStopped         = YES;
        [self.view addSubview:activityView];
        activityView.center = self.view.center;
        [activityView startAnimating];
        
        [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
            //加载动画停止
            [activityView stopAnimating];
            
            if (!error) {
                NSLog(@"%@",recordPath);
                NSLog(@"停止录音");
                
                EMChatVoice *voice = [[EMChatVoice alloc] initWithFile:recordPath displayName:self.soundPath];
                voice.duration = aDuration;
                EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithChatObject:voice];
                EMMessage *message = [[EMMessage alloc] initWithReceiver:self.buddyName bodies:@[body]];
                if (self.isBuddy) {
                    message.messageType = eMessageTypeChat; // 设置为单聊消息
                }else{
                    message.messageType = eMessageTypeGroupChat; // 设置为群聊消息
                }
                //发送消息并滚动到最后一行
                [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:^(EMMessage *message, EMError *error) {
                    NSLog(@"准备发送");
                } onQueue:nil completion:^(EMMessage *message, EMError *error) {
                    NSLog(@"发送成功");
                    //添加到数组,省去重新读取 conversation 的步骤
                    [self.messageArr addObject:message];
                    //插入 cell 并滑动到最后一行
                    NSIndexPath *index = [NSIndexPath indexPathForRow:self.messageArr.count-1 inSection:0];
                    [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
                } onQueue:nil];
                
                self.soundPath = recordPath;
            }
        }];
        
    }
    
    
}
#pragma mark -- avaudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"结束播放");
}

//获取当前时间字符串
- (NSString*)getTimeStr{
    
    //1.获取本地时间
    NSDate* nowDate = [NSDate date];
    // 同 [NSDate alloc] init]
    //2.自定义格式
    NSDateFormatter* fmt = [NSDateFormatter new];
    fmt.dateFormat = @"yyyyMMddHHmmssSSS";
    /**
     *  年 日 时 大小写不区分
     *  月 分 大写表示月 小写表示分
     *  秒 毫秒 小写 s 表示秒  大写 S 表示毫秒
     *  公元 G
     *  周几 EE
     */
    return [fmt stringFromDate:nowDate];
}

@end
