//
//  DiscoverViewController.m
//  weibo
//
//  Created by lushitong on 16/7/29.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "DiscoverViewController.h"
#import "NearbyUserViewController.h"
@interface DiscoverViewController ()

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
}
- (IBAction)NearbyUser:(id)sender {
    NearbyUserViewController *nearby = [[NearbyUserViewController alloc] init];
    nearby.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nearby animated:YES];
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
