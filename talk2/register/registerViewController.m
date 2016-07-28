//
//  registerViewController.m
//  talk2
//
//  Created by 刘森 on 16/5/23.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "registerViewController.h"

@interface registerViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UIActivityIndicatorView* activityView;
@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor alloc] initWithRed:246/255.0 green:247/255.0 blue:239/255.0 alpha:1];
    
    _name.delegate      = self;
    _password.delegate  = self;
    _password2.delegate = self;
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.hidesWhenStopped         = YES;
    [self.view addSubview:_activityView];
    _activityView.center = self.view.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//本地检测账号密码
- (BOOL)checkOut{
    if (_name.text.length>=2 && _password.text.length>=6 && [_password.text isEqualToString:_password2.text]) {
        return YES;
    }
    return NO;
}

//注册跳转
- (IBAction)myRegister:(id)sender {
    if ([self checkOut]) {
        //开始显示加载,注册成功后隐藏
        [_activityView startAnimating];
        [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:_name.text password:_password.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
            [_activityView stopAnimating];
            if (!error) {
                NSLog(@"注册成功");
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //跳转界面
                    [self performSegueWithIdentifier:@"enter" sender:sender];
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                //注册失败
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"注册失败" message:@"用户已存在" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
        } onQueue:dispatch_get_main_queue()];
    }else{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"注册失败" message:@"请检查账号密码格式" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
//点击空白区 收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark textFiled delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString* str = @"^[A-Za-z0-9]*$";
    NSPredicate* pre = [NSPredicate predicateWithFormat:@"self matches %@",str];
    if (textField == _name) {
        return ((textField.text.length-range.length+string.length<=9) && [pre evaluateWithObject:string] == 1);
    }else{
        return ((textField.text.length-range.length+string.length<=12) && [pre evaluateWithObject:string] == 1);
    }
}
//回车 收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - Navigation

//返回跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ((UIButton*)sender == _myRegister) {
        id newVC = segue.destinationViewController;
        [newVC setValue:_name.text forKey:@"strName"];
        [newVC setValue:_password.text forKey:@"strPassword"];
    }
}


@end
