//
//  showImageViewController.m
//  talk2
//
//  Created by 刘森 on 16/6/1.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "showImageViewController.h"
#import "showImageView.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface showImageViewController ()
@property (nonatomic,strong) showImageView      * iv;


@end

@implementation showImageViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //_scale 宽/高
//    if (_scale>=1) {
//        _iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, (HEIGHT-64)/_scale)];
//    }else{
//        _iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, (HEIGHT-64)*_scale, HEIGHT-64)];
//    }
    
    _iv = [[showImageView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    _iv.image = _bigImage;
    [self.view addSubview:_iv];
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
