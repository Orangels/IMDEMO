//
//  videoViewController.m
//  talk2
//
//  Created by 刘森 on 16/6/2.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "videoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface videoViewController ()
@property (nonatomic,strong)MPMoviePlayerController *player;
@end

@implementation videoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:_path]];
    _player.view.frame  = self.view.bounds;
    //停靠模式
    _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_player.view];
    [_player play];
    
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
