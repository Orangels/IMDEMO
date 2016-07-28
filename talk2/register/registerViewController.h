//
//  registerViewController.h
//  talk2
//
//  Created by 刘森 on 16/5/23.
//  Copyright © 2016年 ls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EaseMobSDKFull/EaseMob.h>
@interface registerViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *password2;
@property (strong, nonatomic) IBOutlet UIButton *myRegister;
@property (strong, nonatomic) IBOutlet UIButton *myReturn;

@end
