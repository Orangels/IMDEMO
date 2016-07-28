//
//  addBuddyViewController.m
//  talk2
//
//  Created by 刘森 on 16/5/24.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "addBuddyViewController.h"
#import <EaseMob.h>

@interface addBuddyViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *text;

@end

@implementation addBuddyViewController
- (IBAction)addBuddy:(id)sender {
    EMError* error = nil;
    
    if (_text.text.length!=0) {
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:_name.text message:_text.text error:&error];
        if (isSuccess && !error) {
            NSLog(@"申请成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:_name.text message:@"请求添加好友" error:&error];
        if (isSuccess && !error) {
            NSLog(@"申请成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _name.delegate = self;
    _text.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
