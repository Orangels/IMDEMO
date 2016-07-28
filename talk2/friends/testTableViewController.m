//
//  testTableViewController.m
//  talk2
//
//  Created by 刘森 on 16/5/24.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "testTableViewController.h"
#import "testTableViewController+sendSound.h"
#import "testTableViewController+extension.h"//拓展功能
#import "talkTableViewCell.h"
#import "imageTableViewCell.h"
#import "talkTableViewController.h"
#import "showImageViewController.h"
#import "videoViewController.h"
#import "detailViewController.h"
#import "AppDelegate.h"


@interface testTableViewController ()<EMChatManagerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate>

@end

@implementation testTableViewController

-(void)viewDidAppear:(BOOL)animated{
    //滑动到最后一行
    if (_messageArr.count>0) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:_messageArr.count-1 inSection:0];
        [_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:NO];
        _tableView.hidden = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //移除通知中心
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除_ avplayer
    [_avplayer stop];
    _avplayer = nil;
    //如果还在录音
    if ([[EMCDDeviceManager sharedInstance] isRecording]) {
        //结束录音,删除文件
        [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
           NSFileManager* manager = [NSFileManager defaultManager];
            NSLog(@"%@",recordPath);
            BOOL aaa = [manager removeItemAtPath:recordPath error:nil];
            NSLog(@"%d",aaa);
        }];
        _soundBtn.selected ^= 1;
    }
    //更新 talkTableViewController 界面
    //标记已读
    [_conversation markAllMessagesAsRead:YES];
    
    AppDelegate* app =[UIApplication sharedApplication].delegate;
    UINavigationController* nav = app.tvc.viewControllers[1];
    talkTableViewController* talkVC = nav.viewControllers[0];
    [talkVC loadMyConversation];

    [self.lsPopView dismiss];
    //停止网络监察
    [self.reach stopNotifier];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showConversation];
    //加载会话,获得历史聊天记录
    [self loadConversation];
    //滑动到最后一行
    if (_messageArr.count>0) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:_messageArr.count-1 inSection:0];
        [_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    //注册键盘的通知 ,在 disappear 中 remove 通知
    //将要弹起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //将要收起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}
//键盘弹起
- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary * info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    //输入框位置动画加载
    [self begainMoveUpAnimation:keyboardSize.height];
}
//键盘收起
- (void)keyboardWillHide:(NSNotification *)notification {
    
    [self begainMoveUpAnimation:0];
}
//输入框弹起收起
- (void)begainMoveUpAnimation:(CGFloat)height{
    [UIView animateWithDuration:0.3 animations:^{
        _enterView.frame = CGRectMake(0, HEIGHT+14-height, WITH, 40);
        //lsPopView 鬼祟 enterView 调整 point
        _lsPopView.startY = HEIGHT+14-height-5;
    }];
    _textField.text = @"";
    _textField.enablesReturnKeyAutomatically = YES;
    //tableView 滑动到最后一行
//    [_tableView layoutIfNeeded];
    
    if ([_conversation loadAllMessages].count > 1) {
        
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_conversation.loadAllMessages.count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
    }
}

#pragma mark -- pushInfo 方法 进入对方信息界面
-(IBAction)pushInfo:(UIBarButtonItem*)btn{
    detailViewController* vc = [detailViewController new];
    vc.title                 = self.navigationItem.title;
    vc.isBuddy               = self.isBuddy;
    vc.buddyName             = self.buddyName;
    [self.navigationController pushViewController:vc animated:YES];
}
//获取 conversation
- (void) showConversation{
    if (_isBuddy) {
        self.navigationItem.title = _buddyName;
#warning  没补全功能前,先不显示这个按键
        //        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.title style:UIBarButtonItemStylePlain target:self action:@selector(pushInfo:)];
        //初始化 conversation 单聊会话
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:_buddyName conversationType:eConversationTypeChat];
    }else{
        //初始化 conversation 群聊会话
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:_buddyName conversationType:eConversationTypeGroupChat];
        [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:_buddyName completion:^(EMGroup *group, EMError *error) {
            if (!error) {
                self.navigationItem.title = group.groupSubject;
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.navigationItem.title style:UIBarButtonItemStylePlain target:self action:@selector(pushInfo:)];
            }else{
                NSLog(@"error : %@",error);
            }
        } onQueue:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor alloc] initWithRed:246/255.0 green:247/255.0 blue:239/255.0 alpha:1];
    
    //获取 conversation
    [self showConversation];
    
    //会话标记已读
    [_conversation markAllMessagesAsRead:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _messageArr = [NSMutableArray array];

    //初始化数据,获得历史聊天记录
    [self loadConversation];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [self creatUI];
    _tableView.hidden = YES;
    
}
//创建对话框
- (void)creatUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WITH, HEIGHT-60) style:UITableViewStylePlain];
    self.tableView.delegate       = self;
    self.tableView.dataSource     = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_tableView addGestureRecognizer:tap];
    //tableview 背景图片
    _tableView.backgroundColor = [UIColor clearColor];
//    UIImageView* iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"talkBack.jpg"]];
//    _tableView.backgroundView = iv;
    
    //还要在自定义的 cell 里设置背景颜色为透明色
    [self.view addSubview:_tableView];
    
    //和 tableview 和底边各留 10
    _enterView             = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT+14, WITH, 40)];
    _enterView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_enterView];
    _textField             = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, WITH-100, 40)];
    _textField.placeholder = @"请输入";
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.tintColor   = [UIColor grayColor];
    _textField.returnKeyType = UIReturnKeySend;
    _textField.delegate    = self;
    _textField.enablesReturnKeyAutomatically = YES;
    [_enterView addSubview:_textField];
    //拓展 btn
    _btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn.frame     = CGRectMake(WITH-45, 0, 40, 40);
    [_btn setTitle:@"拓展" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(otherBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_enterView addSubview:_btn];
    //语音 btn
    _soundBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _soundBtn.frame = CGRectMake(10, 0, 40, 40) ;
    [_soundBtn setTitle:@"语音" forState:UIControlStateNormal];
    [_soundBtn setTitle:@"发送" forState:UIControlStateSelected];
    [_soundBtn addTarget:self action:@selector(sendSound:) forControlEvents:UIControlEventTouchUpInside];
    [_enterView addSubview:_soundBtn];
    //创建 lsPopView
    [self creatLsPopView];
}





#warning 拓展功能待补充
//btn 方法,扩展功能,发送图片,地址等;
- (IBAction)otherBtn:(UIButton*)btn{
    
    [self.lsPopView popView];
    
}

//tap 收起键盘
-(IBAction)tap:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

#pragma mark -- textFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.text != 0) {
        _textField.enablesReturnKeyAutomatically = NO;
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_textField.text.length != 0) {
        [self clickSend];
        textField.text = @"";
        return YES;
    }
    return NO;
}

//点击发送信息
-(IBAction)clickSend{
    EMChatText *txtChat = [[EMChatText alloc] initWithText:_textField.text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txtChat];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:_buddyName bodies:@[body]];
    if (_isBuddy) {
        message.messageType = eMessageTypeChat; // 设置为单聊消息
    }else{
        message.messageType = eMessageTypeGroupChat; // 设置为群聊消息
    }
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:^(EMMessage *message, EMError *error) {
        NSLog(@"准备发送");
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        NSLog(@"发送成功");
        //添加到数组,省去重新读取 conversation 的步骤
        [_messageArr addObject:message];
        //插入 cell 并滑动到最后一行
            NSIndexPath *index = [NSIndexPath indexPathForRow:_messageArr.count-1 inSection:0];
            [_tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } onQueue:nil];
}
#pragma mark 接受消息
- (void)didReceiveMessage:(EMMessage *)message{
    //NSString *txt = ((EMTextMessageBody *)msgBody).text;
    //接受到的消息,在生成 cell 里 用 message.from 判断来源
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    //图片 需要手动下载的
    if (msgBody.messageBodyType == eMessageBodyType_Image) {
        [_messageArr addObject:message];
        NSIndexPath *index = [NSIndexPath indexPathForRow:_messageArr.count-1 inSection:0];
        [_tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
        [_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
        [[EaseMob sharedInstance].chatManager asyncFetchMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
            if (!error) {
                [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            }
        } onQueue:nil];
    }//文字 和 语音 不需要手动下载的   视频要点击下载
    if (msgBody.messageBodyType == eMessageBodyType_Text || msgBody.messageBodyType == eMessageBodyType_Voice || msgBody.messageBodyType == eMessageBodyType_Video){
        [_messageArr addObject:message];
        NSIndexPath *index = [NSIndexPath indexPathForRow:_messageArr.count-1 inSection:0];
        [_tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
        [_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

//获得会话中的消息 和 当前用户账号姓名
-(void)loadConversation{
    _messageArr = [NSMutableArray arrayWithArray:[_conversation loadAllMessages]];
    //获得当前用户账号
    UINavigationController* nav = self.navigationController.tabBarController.viewControllers[0];
    _username = nav.viewControllers[0].navigationItem.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _messageArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHight;
    EMMessage *message = _messageArr[indexPath.row];
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text:{
            talkTableViewCell *cell = [[talkTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            // 收到的文字消息
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            cellHight = [cell getLeftStr:@"" andRightStr:txt andTime:@""andName:message.from];
        }
            break;
        case eMessageBodyType_Voice:{
            talkTableViewCell *cell = [[talkTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            cellHight = [cell getLeftStr:@"          " andRightStr:@"" andTime:@""andName:message.from];
        }
            break;
        case eMessageBodyType_Image:{
            cellHight = 100;
        }
            break;
            
        default:
            cellHight = 100;
            break;
        
    }
    return cellHight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    talkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell) {
//        cell = [[talkTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
//    }
#warning 判断单聊群聊,显示名字,头像
    EMMessage *message = _messageArr[indexPath.row];
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            talkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[talkTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            // 收到的文字消息
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            //自己发送的
            if ([message.from isEqualToString:_username]) {
                cell.rightView.hidden = NO;
                cell.leftView.hidden  = YES;
                //单聊 /群聊 名字
                if (message.messageType == eMessageTypeChat) {
                    [cell getLeftStr:@"" andRightStr:txt andTime:@""andName:message.from];
                }else if (message.messageType == eMessageTypeGroupChat){
                    [cell getLeftStr:@"" andRightStr:txt andTime:@""andName:message.groupSenderName];
                }
            }else{//对方发送
                cell.rightView.hidden = YES;
                cell.leftView.hidden  = NO;
                //单聊 /群聊 名字
                if (message.messageType == eMessageTypeChat) {
                    [cell getLeftStr:txt andRightStr:@"" andTime:@""andName:message.from];
                }else if (message.messageType == eMessageTypeGroupChat){
                    [cell getLeftStr:txt andRightStr:@"" andTime:@""andName:message.groupSenderName];
                }
            }
            cell.block = ^(){
                NSLog(@"点击信息");
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }
            
            break;
        case eMessageBodyType_Voice:
        {
            talkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"voiceCell"];
            if (!cell) {
                cell = [[talkTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"voiceCell"];
            }
            // 音频SDK会自动下载
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
            NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
            NSLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用SDK提供的下载方法后才会存在（音频会自动调用）
            //获得文件路径
            NSString* path = [body.localPath stringByDeletingLastPathComponent];
            NSLog(@"音频的文件夹 -- %@"         ,path);
            NSLog(@"音频的secret -- %@"        ,body.secretKey);
            NSLog(@"音频文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"音频文件的下载状态 -- %lu"   ,body.attachmentDownloadStatus);
            NSLog(@"音频的时间长度 -- %lu"      ,body.duration);
            //amr 转 wav
            NSString* wavPath = [NSString stringWithFormat:@"%@/%@",path,[self getTimeStr]];
            [EMVoiceConverter amrToWav:body.localPath wavSavePath:wavPath];
            NSData* wavData = [NSData dataWithContentsOfFile:wavPath];
            cell.block = ^(){
                [_avplayer stop];
                _avplayer = [[AVAudioPlayer alloc]initWithData:wavData error:nil];
                _avplayer.delegate = self;
                [_avplayer prepareToPlay];
                [_avplayer play];
            };
            if ([message.from isEqualToString:_username]) {
                cell.rightView.hidden = NO;
                cell.leftView.hidden  = YES;
                
                if (message.messageType == eMessageTypeChat) {
                    [cell getLeftStr:@"" andRightStr:@"          " andTime:[NSString stringWithFormat:@"%lu\"",body.duration]andName:message.from];
                }else if (message.messageType == eMessageTypeGroupChat){
                    [cell getLeftStr:@"" andRightStr:@"          " andTime:[NSString stringWithFormat:@"%lu\"",body.duration]andName:message.groupSenderName];
                }

            }else{//对方发送
                cell.rightView.hidden = YES;
                cell.leftView.hidden  = NO;
                if (message.messageType == eMessageTypeChat) {
                    [cell getLeftStr:@"          " andRightStr:@"" andTime:[NSString stringWithFormat:@"%lu\"",body.duration]andName:message.from];
                }else if (message.messageType == eMessageTypeGroupChat){
                    [cell getLeftStr:@"          " andRightStr:@"" andTime:[NSString stringWithFormat:@"%lu\"",body.duration]andName:message.groupSenderName];
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }
            break;
            //图片
        case eMessageBodyType_Image:
        {
            // 得到一个图片消息body
            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
            NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
            NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用SDK提供的下载方法后才会存在
            NSLog(@"大图的secret -- %@"    ,body.secretKey);
            NSLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
            NSLog(@"大图的下载状态 -- %lu",body.attachmentDownloadStatus);
            
            
            // 缩略图sdk会自动下载
            NSLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
            NSLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
            NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
            NSLog(@"小图的W -- %f ,大图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
            NSLog(@"小图的下载状态 -- %lu",body.thumbnailDownloadStatus);
            //判断大图下载状态
            if (body.attachmentDownloadStatus != 1) {
                [[EaseMob sharedInstance].chatManager asyncFetchMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                    if (!error) {
                        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                } onQueue:nil];
            }
            
            imageTableViewCell* imageCell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
            imageCell = [[imageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"imageCell"];
            
            if ([message.from isEqualToString:_username]) {
                //自己发送的
                if (message.messageType == eMessageTypeChat) {
                    //单聊
                    [imageCell showlitImage:body.thumbnailLocalPath andBigImage:body.localPath andFrom:NO andName:message.from ];
                }else if (message.messageType == eMessageTypeGroupChat){
                    //群聊
                    [imageCell showlitImage:body.thumbnailLocalPath andBigImage:body.localPath andFrom:NO andName:message.groupSenderName];
                }
                
            }else{
                //对方发送的
                //自己发送的
                if (message.messageType == eMessageTypeChat) {
                    //单聊
                    [imageCell showlitImage:body.thumbnailLocalPath andBigImage:body.localPath andFrom:YES andName:message.from];
                }else if (message.messageType == eMessageTypeGroupChat){
                    //群聊
                    [imageCell showlitImage:body.thumbnailLocalPath andBigImage:body.localPath andFrom:YES andName:message.groupSenderName];
                }
            }
            //这里把大图片传递给了 cell 做了一个传递,转换成 uiimage, 没有必要,可以直接使用 body.localPath 转换成图片
            imageCell.block = ^(UIImage* image){
                showImageViewController* showImageVC = [showImageViewController new];
                showImageVC.scale = body.size.width/body.size.height;
                showImageVC.bigImage = image;
                showImageVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:showImageVC animated:YES];
            };
            
            return imageCell;
        }
            break;
        case eMessageBodyType_Video:
        {
            EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
            
            NSLog(@"视频remote路径 -- %@"      ,body.remotePath);
            NSLog(@"视频local路径 -- %@"       ,body.localPath ); // 需要使用SDK提供的下载方法后才会存在
            NSLog(@"视频的secret -- %@"        ,body.secretKey);
            NSLog(@"视频文件大小 -- %lld"       ,body.fileLength);
            NSLog(@"视频文件的下载状态 -- %lu"   ,body.attachmentDownloadStatus);
            NSLog(@"视频的时间长度 -- %lu"      ,body.duration);
            NSLog(@"视频的W -- %f ,视频的H -- %f", body.size.width, body.size.height);
            
            // 缩略图sdk会自动下载
            NSLog(@"缩略图的remote路径 -- %@"     ,body.thumbnailRemotePath);
            NSLog(@"缩略图的local路径 -- %@"      ,body.thumbnailRemotePath);
            NSLog(@"缩略图的secret -- %@"        ,body.thumbnailSecretKey);
            NSLog(@"缩略图的下载状态 -- %lu"      ,body.thumbnailDownloadStatus);
            
            //获得文件路径, 这里视频缩略图路径有问题, 自己拼接一下
            NSString* path = [body.localPath stringByDeletingLastPathComponent];
            //追加路径 拼接成本地缩略图路径
            if (body.thumbnailRemotePath) {
                path = [path stringByAppendingPathComponent:[body.thumbnailRemotePath lastPathComponent]];
            }else{
                path = nil;
            }
            
            imageTableViewCell* videoCell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];
            videoCell = [[imageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"videoCell"];
            //判断谁发送的
            if ([message.from isEqualToString:_username]) {
                //自己发送的
                if (message.messageType == eMessageTypeChat) {
                    //单聊
                    [videoCell showVideoImage:path andFrom:NO andName:[NSString stringWithFormat:@"%@:%lld KB",message.from,body.fileLength/1000] andVideoPath:body.localPath];
                }else if (message.messageType == eMessageTypeGroupChat){
                    //群聊
                    [videoCell showVideoImage:path andFrom:NO andName:[NSString stringWithFormat:@"%@:%lld KB",message.groupSenderName,body.fileLength/1000] andVideoPath:body.localPath];
                }
                
            }else{
                //对方发送的
                if (message.messageType == eMessageTypeChat) {
                    //单聊
                    [videoCell showVideoImage:path andFrom:YES andName:[NSString stringWithFormat:@"%@:%lld KB",message.from,body.fileLength/1000] andVideoPath:body.localPath];;
                }else if (message.messageType == eMessageTypeGroupChat){
                    //群聊
                    [videoCell showVideoImage:path andFrom:YES andName:[NSString stringWithFormat:@"%@:%lld KB",message.groupSenderName,body.fileLength/1000] andVideoPath:body.localPath];
                }
            }

            __weak typeof(videoCell) weakVideolCell = videoCell;
            
            videoCell.block = ^(UIImage* image){
                if (videoCell.progress.progress == 0) {
                    [weakVideolCell.progress setProgress:0.5 animated:YES];
                    [[EaseMob sharedInstance].chatManager asyncFetchMessage:message progress:weakVideolCell.progress completion:^(EMMessage *aMessage, EMError *error) {
                        if (!error) {
                            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    } onQueue:nil];
                }
                if (videoCell.progress.progress == 1) {
                    videoViewController* videoVC = [videoViewController new];
                    videoVC.path = body.localPath;
                    [self.navigationController pushViewController:videoVC animated:YES];
                }
            };
            return videoCell;
        }
            
            break;
            
        default:
            break;
    }
    //没用的 cell
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"nocell"];
    
    return cell;
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
