//
//  mapViewController.m
//  talk2
//
//  Created by 刘森 on 16/6/1.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "mapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface mapViewController ()<MAMapViewDelegate>{
    MAMapView *_mapView;
    
}

@end

@implementation mapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AMapServices sharedServices].apiKey = @"ed3965c9af8fc932a4fe579788d1da3e";
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
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
