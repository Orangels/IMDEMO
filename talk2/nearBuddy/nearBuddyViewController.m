//
//  nearBuddyViewController.m
//  talk2
//
//  Created by 刘森 on 16/6/5.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "nearBuddyViewController.h"
#import "AppDelegate.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import "testTableViewController.h"

#import <CoreLocation/CoreLocation.h>


@interface nearBuddyViewController ()<AMapNearbySearchManagerDelegate,MAMapViewDelegate,CLLocationManagerDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>{
    AMapNearbySearchManager *_nearbyManager;
    MAMapView *_mapView;
    CLLocationManager* locationManager;
    AMapSearchAPI *_search;
}

@property (strong,nonatomic) CLLocationManager * locationManager;
@property (nonatomic,strong) NSMutableArray    * nearBuddyArr;
@property (nonatomic,copy  ) NSString          * userName;
@property (nonatomic,strong) UITableView       * tableView;
@property (nonatomic,strong) UIRefreshControl  * refresh;
@end

@implementation nearBuddyViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    _mapView.showsUserLocation = NO;//YES 为打开定位，NO为关闭定位
#warning  这里暂时有问题, 当清除信息以后,即使再次上传信息 也会搜索不到,要退出 app 再登陆才会搜索到
    //清除个人信息,不再被搜索到
//    [_nearbyManager clearUserInfoWithID:_userName];
}

- (void)initializeLocationService {
    
    //初始化定位管理器
    
    _locationManager= [[CLLocationManager alloc]init];
    
    //设置代理
    
    _locationManager.delegate=self;
    
    //设置定位精确度到米
    
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    
    //设置过滤器为无
    
    _locationManager.distanceFilter=kCLDistanceFilterNone;
    
    //开始定位
    
    [_locationManager requestAlwaysAuthorization];//这句话ios8以上版本使用。
    
    [_locationManager  startUpdatingLocation];
}
//系统定位回调
- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation {
    [locationManager stopUpdatingLocation];
    
    NSLog(@"定位成功...");
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    CLGeocoder* geoCoder = [[CLGeocoder alloc]init];
#if 0
    //根据经纬度反向地理编译出地址信息
    
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray*array,NSError*error){
        
        if(array.count>0){
            
            CLPlacemark*placemark = [array objectAtIndex:0];
            
            //将获得的所有信息显示到导航栏上
            
//            _titleLab.text= [NSString stringWithFormat:@"%@%@",placemark.locality,placemark.subLocality];
            
            //获取城市
            
            NSString*city = placemark.locality;
            
            if(!city) {
                
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                
                city = placemark.administrativeArea;
                
            }
            
            NSLog(@"city = %@", city);
            
        }
        
        else if(error ==nil&& [array count] ==0)
            
        {
            
            NSLog(@"No results were returned.");
            
        }
        
        else if(error !=nil)
            
        {
            
            NSLog(@"An error occurred = %@", error);
            
        }
        
    }];
    
#endif
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    
    [manager  stopUpdatingLocation];
    
    
    //构造上传数据对象
    AMapNearbyUploadInfo *info = [[AMapNearbyUploadInfo alloc] init];
    info.userID = _userName;//业务逻辑id
    info.coordinateType = AMapSearchCoordinateTypeGPS;//坐标系类型
    info.coordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);//用户位置信息
    
    if ([_nearbyManager uploadNearbyInfo:info])
    {
        NSLog(@"YES");
    }
    else
    {
        NSLog(@"NO");
    }
    
}
#pragma mark -- viewDidLoad
- (void)viewDidLoad{
    [super viewDidLoad];
    
    //初始化数组
    _nearBuddyArr = [NSMutableArray array];
    
    //本地地推定位
//    [self   initializeLocationService];
    
    self.view.backgroundColor = [UIColor whiteColor];
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    _userName        = app.username;
    
    //搜索代理
    _mapView                   = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _nearbyManager             = [AMapNearbySearchManager sharedInstance];
    _search                    = [[AMapSearchAPI alloc] init];
    
    _search.delegate           = self;
    _nearbyManager.delegate    = self;
    _mapView.delegate          = self;
    //定位
    _mapView.showsUserLocation = YES;//YES 为打开定位，NO为关闭定位
    _mapView.userTrackingMode  = MAUserTrackingModeFollow;
    //布局 UI
    [self creatUI];

}

//定位回调
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        //构造上传数据对象
        AMapNearbyUploadInfo *info = [[AMapNearbyUploadInfo alloc] init];
        info.userID = _userName;//上传账号
        info.coordinateType = AMapSearchCoordinateTypeAMap;//坐标系类型
        info.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude,userLocation.coordinate.longitude );//用户位置信息
        
        if ([_nearbyManager uploadNearbyInfo:info])
        {
            NSLog(@"YES");
        }
        else
        {
            NSLog(@"NO");
        }
        //所搜周边 buddy
        [self searchNearBuddyWithUserLocation:userLocation];
    }
    _mapView.showsUserLocation = NO;
    
}

- (void)searchNearBuddyWithUserLocation:(MAUserLocation *)userLocation{
    AMapNearbySearchRequest *request = [[AMapNearbySearchRequest alloc] init];
    request.center = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];//中心点
    request.radius = 10000;//搜索半径
    request.timeRange = 1800;//查询的时间
    request.searchType = AMapNearbySearchTypeDriving;//驾车距离，AMapNearbySearchTypeLiner表示直线距离
    //发起附近周边搜索
    [_search AMapNearbySearch:request];
}

//附近周边搜索回调
- (void)onNearbySearchDone:(AMapNearbySearchRequest *)request response:(AMapNearbySearchResponse *)response
{
    if(response.infos.count == 0)
    {
        return;
    }
    [_nearBuddyArr removeAllObjects];
    _nearBuddyArr = [NSMutableArray arrayWithArray:response.infos];
    //block 块遍历 ,删除自己  测试时可以注掉
    [_nearBuddyArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AMapNearbyUserInfo *info = obj;
        if ([info.userID isEqualToString:_userName]) {
            [_nearBuddyArr removeObject:obj];
             }
        }];
    [_tableView reloadData];
#if 0
    for (AMapNearbyUserInfo *info in response.infos)
    {
//      向地图添加标注,这里不用
        MAPointAnnotation *anno = [[MAPointAnnotation alloc] init];
        anno.title              = info.userID;
        anno.subtitle           = [[NSDate dateWithTimeIntervalSince1970:info.updatetime] descriptionWithLocale:[NSLocale currentLocale]];
        anno.coordinate         = CLLocationCoordinate2DMake(info.location.latitude, info.location.longitude);
//        [_mapView addAnnotation:anno];
    }
#endif
}
#pragma mark -- 布局 UI
//创建 tableView
- (void)creatUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView                                = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    _tableView.delegate                       = self;
    _tableView.dataSource                     = self;
    _tableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
    _refresh = [UIRefreshControl new];
    _refresh.tintColor = [UIColor blueColor];
    _refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [_refresh addTarget:self action:@selector(searchNearBuddy:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refresh];
    [self.view addSubview:_tableView];
}
//刷新,重新搜索
- (IBAction)searchNearBuddy:(UIRefreshControl*)refresh{
    _mapView.showsUserLocation = YES;//YES 为打开定位，NO为关闭定位
    [refresh endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _nearBuddyArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    AMapNearbyUserInfo *info = _nearBuddyArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"chatListCellHead"];
    cell.textLabel.text = info.userID;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"距离: %.f 米",info.distance];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AMapNearbyUserInfo *info = _nearBuddyArr[indexPath.row];
    
    testTableViewController* vc = [testTableViewController new];
    vc.isBuddy = YES;
    vc.buddyName = info.userID;
    [self.navigationController pushViewController:vc animated:YES];
}
















@end
