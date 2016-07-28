//
//  alowBuddyViewController.m
//  talk2
//
//  Created by 刘森 on 16/5/24.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "alowBuddyViewController.h"
#import "EaseMob.h"
#import "buddyTableViewController.h"
@interface alowBuddyViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *reason;

@end

@implementation alowBuddyViewController
- (IBAction)alow:(id)sender {
    
    NSString* username = _dic[@"username"];
    
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error];
    if (isSuccess && !error) {
        NSLog(@"发送同意成功");
        _block(_dic);
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)reject:(id)sender {
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:_dic[@"username"] reason:_reason.text error:&error];
    if (isSuccess && !error) {
        NSLog(@"发送拒绝成功");
        _block(_dic);
        [self.navigationController popViewControllerAnimated:YES];
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
    self.reason.delegate = self;
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
