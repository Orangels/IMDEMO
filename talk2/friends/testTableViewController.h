//
//  testTableViewController.h
//  talk2
//
//  Created by 刘森 on 16/5/24.
//  Copyright © 2016年 ls. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EaseMob.h"

#import "EMVoiceConverter.h"
#import "EMCDDeviceManager.h"
#import "Reachability.h" //检测网络状态
#import <AVFoundation/AVFoundation.h>
#import "lsView.h"

#define WITH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height-64

#define NSEaseLocalizedString(key, comment) [[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"EaseUIResource" withExtension:@"bundle"]] localizedStringForKey:(key) value:@"" table:nil]


@interface testTableViewController : UIViewController
@property (nonatomic,copy) NSString* buddyName;
@property (nonatomic,assign)BOOL isBuddy;

@property (nonatomic,strong) EMConversation * conversation;
@property (nonatomic,strong) NSMutableArray * messageArr;
@property (nonatomic,strong) UITextField    * textField;
@property (nonatomic,strong) UITableView    * tableView;
@property (nonatomic,copy  ) NSString       * username;
@property (nonatomic,strong) UIView         * enterView;
@property (nonatomic,strong) AVAudioPlayer  * avplayer;
@property (nonatomic,copy  ) NSString       * soundPath;
@property (nonatomic,strong) UIButton       * soundBtn;
@property (nonatomic,strong) UIButton       * btn;//拓展 button
@property (nonatomic,strong) lsView         * lsPopView;
@property (nonatomic,strong) Reachability   * reach;

@end
