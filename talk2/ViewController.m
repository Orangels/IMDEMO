//
//  ViewController.m
//  talk2
//
//  Created by 刘森 on 16/5/23.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "ViewController.h"
#import <EaseMobSDKFull/EaseMob.h>
#import "lsTabBarController.h"
#import "AppDelegate.h"
#import "Header.h"
#import "loadViewController.h"
@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController

- (IBAction)login:(id)sender {
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:_name.text password:_password.text completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error) {
            //设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            NSLog(@"登录成功");
            NSLog(@"%@",loginInfo);
            //写入本地 Plist 文件
#warning 关于更新头像和昵称,这里应该用消息的拓展来传递用户头像和昵称,这里暂时没有设置消息的拓展,所以先简单的做判断,如果本地有过当前用户的登录数据,就用本地数据,如果没有则生成默认数据(缺点:在A设备更新数据后,B 设备不会更新到数据,只能用到本地的数据)
            Person* person = [Person PersonWithName:_name.text];
            NSLog(@"%@",person);
            NSDictionary* userDic = [NSDictionary dictionaryWithContentsOfFile:USERPAH];
            for (NSString* str in userDic) {
                if ([str isEqualToString:_name.text]) {
                    person = [[Person alloc] initWithDictionary:userDic[str] error:nil];
                    break;
                }
            }
            
            [userDic setValue:[person toDictionary] forKey:_name.text];
            NSLog(@"%@",userDic);
            BOOL suc= [userDic writeToFile:USERPAH atomically:YES];
            if (suc) {
                NSLog(@"写入成功");
            }else{
                NSLog(@"写入失败");
            }
            
            lsTabBarController* lstvc   = [lsTabBarController new];
            [lstvc creatTabBarController];

            UINavigationController* nav = lstvc.viewControllers[0];
            loadViewController* loadVC  = nav.viewControllers[0];
            loadVC.person               = person;
            
            for (UINavigationController* nav in lstvc.viewControllers) {
                UIViewController* vc = nav.viewControllers[0];
                vc.navigationItem.title = _name.text;
            }
            
            AppDelegate* app =[UIApplication sharedApplication].delegate;
            app.username = _name.text;
            app.tvc = lstvc;
            self.view.window.rootViewController = lstvc;
            
        }else{
            //登录失败
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"登录失败" message:@"请检查账号密码是否正确" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    } onQueue:nil];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _name.text     = _strName;
    _password.text = _strPassword;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor alloc] initWithRed:246/255.0 green:247/255.0 blue:239/255.0 alpha:1];
    
    _password.delegate        = self;
    _name.delegate            = self;
    _password.secureTextEntry = YES;
}

#pragma mark textfieldDelegate{
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}


/*
#if 0
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"login"]) {
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:_name.text password:_password.text completion:^(NSDictionary *loginInfo, EMError *error) {
            if (!error && loginInfo) {
                //设置自动登录
                [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                NSLog(@"登录成功");
            }
        } onQueue:nil];
    }
}
#endif
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
