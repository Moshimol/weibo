//
//  LocationViewController.m
//  weibo
//
//  Created by lushitong on 16/8/8.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#define kSinaweibolocationAPI @"place/nearby/pois.json"
@interface LocationViewController ()<CLLocationManagerDelegate,SinaWeiboRequestDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    CLLocationManager *_locationManager;
    NSArray *_locationArray;
    UITableView *_tableView;
}

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"开启定位服务";
    [self creatTableView];
    [self startLocation];
    
}
#pragma -mark 开启定位服务
-(void)startLocation{
    _locationManager = [[CLLocationManager alloc]init];
    
    if (kSystemVersion > 8 ) {
        [_locationManager requestWhenInUseAuthorization];
    }
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.delegate =self;
    [_locationManager startUpdatingLocation];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    //    NSLog(@"locations = %@",locations);
    
    [manager stopUpdatingHeading];
    CLLocation *location = [locations firstObject];
    double lon = location.coordinate.longitude;
    double lat  = location.coordinate.latitude;
    NSLog(@"精度%f,维度%f",lon,lat);
    
    SinaWeibo *wb = kSinaWeiboObject;
    NSDictionary *param = @{@"long":[NSString stringWithFormat:@"%f",lon],
                            @"lat":[NSString stringWithFormat:@"%f",lat]};
    [wb requestWithURL:kSinaweibolocationAPI params:[param mutableCopy] httpMethod:@"GET" delegate:self];
    
}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    
    _locationArray = result[@"pois"];
    [_tableView reloadData];
    
}
#pragma -mark 单元格的创建
-(void)creatTableView{
    
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource= self;
    
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _locationArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell==nil) {
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSDictionary *dic = _locationArray[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    if (![dic[@"address"] isKindOfClass:[NSNull class]]) {
        cell.detailTextLabel.text = dic[@"address"];
    }
    else{
        
        cell.detailTextLabel.text=nil;
    }
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"icon"]]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_block) {
        _block(_locationArray[indexPath.row]);
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addLocationResultBlock:(LocationResultBlock)block{
    
    _block = [block copy];
}


@end
