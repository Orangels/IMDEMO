//
//  ViewController.h
//  talk2
//
//  Created by 刘森 on 16/5/23.
//  Copyright © 2016年 ls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "lsTabBarController.h"
@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField        *name;
@property (strong, nonatomic) IBOutlet UITextField        *password;
@property (strong, nonatomic) IBOutlet UIButton           *login;
@property (strong, nonatomic) IBOutlet UIButton           *myRegister;
@property (nonatomic,copy   ) NSString           * strName;
@property (nonatomic,copy   ) NSString           * strPassword;
//@property (nonatomic,strong ) lsTabBarController * tvc;
@end

