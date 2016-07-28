//
//  AppDelegate.m
//  talk2
//
//  Created by 刘森 on 16/5/23.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "loadViewController.h"
#import "buddyTableViewController.h"
#import "talkTableViewController.h"
#import "testTableViewController.h"
//三方 SDK
#import <EaseMobSDKFull/EaseMob.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#import "Header.h"

@interface AppDelegate ()<IChatManagerDelegate>
@property (nonatomic,strong) NSMutableArray * requestBuddyArr;
@property (nonatomic,strong) EMMessage      * message;
@property (nonatomic,assign) NSInteger        num;//未读消息数
@end

@implementation AppDelegate
//接受本地推送回调
#if 1
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    testTableViewController* ttvc = [testTableViewController new];
    NSString* from                = notification.userInfo[@"message.from"];
    NSString* isBuddy             = notification.userInfo[@"isBuddy"];
//单聊
    if ([isBuddy isEqualToString:@"yes"]) {
        ttvc.isBuddy = YES;
        //群聊
    }else if ([isBuddy isEqualToString:@"no"]){
        ttvc.isBuddy = NO;
    }
    ttvc.buddyName   = from;
    ttvc.hidesBottomBarWhenPushed  = YES;
    //获得消息界面
    UINavigationController* nav    = _tvc.viewControllers[1];
    _tvc.selectedIndex             = 1;
    self.window.rootViewController = _tvc;
    //这里要做一个判断,如果 是在 nav 的2级或更多级界面,要返回 topViewController
    if (nav.viewControllers.count > 1) {
        [nav popToRootViewControllerAnimated:NO];
    }
    [nav pushViewController:ttvc animated:YES];
    
}
#endif
//接受在线消息
- (void)didReceiveMessage:(EMMessage *)message{
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    
    if ( msgBody.messageBodyType == eMessageBodyType_Text ) {
        _message                   = message;
        //暂时认定 只有文字
        NSString *txt              = ((EMTextMessageBody *)msgBody).text;
        NSLog(@"接受到新消息");
        //更新 talkTableViewController 界面
#pragma mark -- 后台推送
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            //设置后台推送
            UILocalNotification* noti = [[UILocalNotification alloc] init];
            if (noti) {
                //推送时间
                noti.fireDate       = [NSDate date];
                //设置推送循环次数
                noti.repeatInterval = 0;
                //设置默认时区 格林威治时区
                noti.timeZone       = [NSTimeZone defaultTimeZone];
                //推送内容

                NSString* str       = [NSString string];
                //单聊
                if (message.messageType == eMessageTypeChat) {
                    str            = @"yes";
                    noti.alertBody = [NSString stringWithFormat:@"%@ : %@",message.from,txt];
                }else {//群聊
                    str            = @"no";
                    //获取群信息,用 同步方法
                    EMGroup* group = [[EaseMob sharedInstance].chatManager fetchGroupInfo:message.from error:nil];
                    noti.alertBody = [NSString stringWithFormat:@"%@ : %@",group.groupSubject,txt];
                    
                }
                //传递消息信息
                noti.userInfo  = @{@"message.from":message.from,@"isBuddy":str};
                //设置推送声音
                noti.soundName                  = UILocalNotificationDefaultSoundName;
                //设置未读标徽
                noti.applicationIconBadgeNumber = ++_num;
                //发送通知
                [[UIApplication sharedApplication] scheduleLocalNotification:noti];
            }
        }
    }
    //图片
    if ( msgBody.messageBodyType == eMessageBodyType_Image ) {
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            //设置后台推送
            UILocalNotification* noti = [[UILocalNotification alloc] init];
            if (noti) {
                //推送时间
                noti.fireDate       = [NSDate date];
                //设置推送循环次数
                noti.repeatInterval = 0;
                //设置默认时区 格林威治时区
                noti.timeZone       = [NSTimeZone defaultTimeZone];
                //推送内容
                
                NSString* str       = [NSString string];
                //单聊
                if (message.messageType == eMessageTypeChat) {
                    str            = @"yes";
                    noti.alertBody = [NSString stringWithFormat:@"%@ : 图片",message.from];
                }else {//群聊
                    str            = @"no";
                    //获取群信息,用 同步方法
                    EMGroup* group = [[EaseMob sharedInstance].chatManager fetchGroupInfo:message.from error:nil];
                    noti.alertBody = [NSString stringWithFormat:@"%@ : 图片",group.groupSubject];
                    
                }
                //传递消息信息
                noti.userInfo  = @{@"message.from":message.from,@"isBuddy":str};
                //设置推送声音
                noti.soundName                  = UILocalNotificationDefaultSoundName;
                //设置未读标徽
                noti.applicationIconBadgeNumber = ++_num;
                //发送通知
                [[UIApplication sharedApplication] scheduleLocalNotification:noti];
            }
        }
    }//语音
    if (msgBody.messageBodyType == eMessageBodyType_Voice) {
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            //设置后台推送
            UILocalNotification* noti = [[UILocalNotification alloc] init];
            if (noti) {
                //推送时间
                noti.fireDate       = [NSDate date];
                //设置推送循环次数
                noti.repeatInterval = 0;
                //设置默认时区 格林威治时区
                noti.timeZone       = [NSTimeZone defaultTimeZone];
                //推送内容
                
                NSString* str       = [NSString string];
                //单聊
                if (message.messageType == eMessageTypeChat) {
                    str            = @"yes";
                    noti.alertBody = [NSString stringWithFormat:@"%@ : 语音",message.from];
                }else {//群聊
                    str            = @"no";
                    //获取群信息,用 同步方法
                    EMGroup* group = [[EaseMob sharedInstance].chatManager fetchGroupInfo:message.from error:nil];
                    noti.alertBody = [NSString stringWithFormat:@"%@ : 语音",group.groupSubject];
                    
                }
                //传递消息信息
                noti.userInfo  = @{@"message.from":message.from,@"isBuddy":str};
                //设置推送声音
                noti.soundName                  = UILocalNotificationDefaultSoundName;
                //设置未读标徽
                noti.applicationIconBadgeNumber = ++_num;
                //发送通知
                [[UIApplication sharedApplication] scheduleLocalNotification:noti];
            }
        }
    }//视频
    if (msgBody.messageBodyType == eMessageBodyType_Video){
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            //设置后台推送
            UILocalNotification* noti = [[UILocalNotification alloc] init];
            if (noti) {
                //推送时间
                noti.fireDate       = [NSDate date];
                //设置推送循环次数
                noti.repeatInterval = 0;
                //设置默认时区 格林威治时区
                noti.timeZone       = [NSTimeZone defaultTimeZone];
                //推送内容
                
                NSString* str       = [NSString string];
                //单聊
                if (message.messageType == eMessageTypeChat) {
                    str            = @"yes";
                    noti.alertBody = [NSString stringWithFormat:@"%@ : 视频",message.from];
                }else {//群聊
                    str            = @"no";
                    //获取群信息,用 同步方法
                    EMGroup* group = [[EaseMob sharedInstance].chatManager fetchGroupInfo:message.from error:nil];
                    noti.alertBody = [NSString stringWithFormat:@"%@ : 视频",group.groupSubject];
                    
                }
                //传递消息信息
                noti.userInfo  = @{@"message.from":message.from,@"isBuddy":str};
                //设置推送声音
                noti.soundName                  = UILocalNotificationDefaultSoundName;
                //设置未读标徽
                noti.applicationIconBadgeNumber = ++_num;
                //发送通知
                [[UIApplication sharedApplication] scheduleLocalNotification:noti];
            }
        }
        
    }
    //更新 talkTableViewController 界面
    UINavigationController* nav = _tvc.viewControllers[1];
    talkTableViewController* talkVC = nav.viewControllers[0];
    [talkVC loadMyConversation];

#warning  待补充 更新 talkTableViewController 界面
}
//接受到离线消息
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages{
    NSLog(@"%@",offlineMessages);
}

//对方接受好友申请回调
- (void)didAcceptedByBuddy:(NSString *)username{
    UINavigationController* nav = _tvc.viewControllers[2];
    buddyTableViewController* btvc = nav.viewControllers[0];
    [btvc getList];
    [btvc.tableView reloadData];
}
//对方拒绝好友申请回调
- (void)didRejectedByBuddy:(NSString *)username{
//    UINavigationController* nav = _tvc.viewControllers[2];
//    buddyTableViewController* btvc = nav.viewControllers[0];
}

//有好友申请回调
-(void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message
{
    _requestBuddyArr = [NSMutableArray array];
    if (!message) {
        message = @"请求添加好友";
    }
    NSDictionary* dic = @{@"username":username,@"message":message};
    
    [_requestBuddyArr addObject:dic];
    UINavigationController* nav = _tvc.viewControllers[2];
    buddyTableViewController* btvc = nav.viewControllers[0];
    btvc.requestBuddyArr = _requestBuddyArr;
    [btvc.tableView reloadData];
    NSLog(@"收到好友申请");    

}

//将要自动登录回调
- (void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
    _username = loginInfo[@"username"];
    for (UINavigationController* nav in _tvc.viewControllers) {
        UIViewController* vc = nav.viewControllers[0];
        vc.navigationItem.title               = _username;
        
        if ([vc isMemberOfClass:[loadViewController class]]) {
            //读取本地 Plist
            NSDictionary* dic          = [NSDictionary dictionaryWithContentsOfFile:USERPAH];
            Person* per                = [[Person alloc] initWithDictionary:dic[_username] error:nil];
            loadViewController* loadVC = (loadViewController*)vc;
            loadVC.person              = per;
            [loadVC creatUI];
        }
    }
    
}
//已经自动回调
- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error{
    NSLog(@"**********************************");
    NSLog(@"%@",loginInfo);
    NSLog(@"**********************************");
}
//账号在其他设备登陆
- (void)didLoginFromOtherDevice{
    //退出登录
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前账号已在其他设备登录,请检查密码" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
            if (!error) {
                NSLog(@"退出成功");
                NSLog(@"%@",info);
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                ViewController* vc = [story instantiateViewControllerWithIdentifier:@"ViewController"];
                
                //            UINavigationController* nav = self.navigationController.tabBarController.viewControllers[2];
                //            buddyTableViewController* btvc = nav.viewControllers[0];
                //            [btvc dataRefresh];
                
                self.window.rootViewController = vc;
            }
        } onQueue:nil];
    }];
    [alert addAction:action];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    
    
    
}

#pragma mark -- 推送回调
// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    NSLog(@"error -- %@",error);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //统一设置某控件样式/默认样式
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITableView appearance] setRowHeight:70];
    
    
    _num = 0;
#warning mapKey
    [AMapServices sharedServices].apiKey = @"ed3965c9af8fc932a4fe579788d1da3e";
    
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //registerSDKWithAppKey: 注册的AppKey，详细见下面注释。
    //apnsCertName: 推送证书名（不需要加后缀），详细见下面注释。
    //otherConfig:@{kSDKConfigEnableConsoleLogger:@0}  去除打印的设置  , 1 是有打印
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"yoc#wower" apnsCertName:@"wower" otherConfig:@{kSDKConfigEnableConsoleLogger:@0}];
    //ios8 推送设置 本地推送
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
    
    
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController* vc = [story instantiateViewControllerWithIdentifier:@"ViewController"];
    
    _tvc = [lsTabBarController new];
    [_tvc creatTabBarController];
    
    
    BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    if (isAutoLogin) {
        self.window.rootViewController = _tvc;
    }else{
        self.window.rootViewController = vc;
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //设置未读信息清零
    _num = 0;
    application.applicationIconBadgeNumber = _num;
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

// 程序销毁
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    [[EaseMob sharedInstance] applicationWillTerminate:application];

    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ls.talk2" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"talk2" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"talk2.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
