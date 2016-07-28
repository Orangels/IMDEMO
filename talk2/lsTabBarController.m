//
//  lsTabBarController.m
//  talk2
//
//  Created by 刘森 on 16/5/24.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "lsTabBarController.h"
#import "loadViewController.h"
#import "talkTableViewController.h"
#import "buddyTableViewController.h"
@interface lsTabBarController ()

@end

@implementation lsTabBarController


- (void)creatTabBarController{
    loadViewController* loadTVC = [loadViewController new];
    loadTVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"global_btn_bottom_my~iphone"] selectedImage:[UIImage imageNamed:@"global_btn_bottom_my_press~iphone"]];
    UINavigationController* nav1 = [[UINavigationController alloc] initWithRootViewController:loadTVC];
    
    talkTableViewController* talkTVC = [talkTableViewController new];
    talkTVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"会话" image:[UIImage imageNamed:@"global_btn_bottom_play~iphone"] selectedImage:[UIImage imageNamed:@"global_btn_bottom_play_press~iphone"]];
    UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:talkTVC];
    
    buddyTableViewController* buddyTVC = [buddyTableViewController new];
    buddyTVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"好友" image:[UIImage imageNamed:@"global_btn_bottom_friend~iphone"] selectedImage:[UIImage imageNamed:@"global_btn_bottom_friend_press~iphone"]];
    UINavigationController* nav3 = [[UINavigationController alloc] initWithRootViewController:buddyTVC];
    self.viewControllers  = @[nav1,nav2,nav3];

}


- (void)viewDidLoad {
    [super viewDidLoad];
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
