//
//  ProfileViewController.m
//  weibo
//
//  Created by lushitong on 16/7/29.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "TableViewCell.h"
#import "WeiboCellLauout.h"
#import "YYModel.h"
#import "UserHeaderView.h"
@class  WeiboCellLauout;

@interface ProfileViewController () <SinaWeiboRequestDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_weiboArray;
    UserModel *_me;
    UITableView *_table;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    [self loadWeiboData];
    [self loadUserData];
    
    [self createTableView];
}

#pragma mark - 数据处理
- (void)loadUserData {
    SinaWeibo *wb = kSinaWeiboObject;
    if ([wb isAuthValid]) {
        NSDictionary *dic = @{@"uid" : wb.userID};
        
        SinaWeiboRequest *request = [wb requestWithURL:@"users/show.json" params:[dic mutableCopy] httpMethod:@"GET" delegate:self];
        request.tag = 1;
    }
}

- (void)loadWeiboData {
    SinaWeibo *wb = kSinaWeiboObject;
    if ([wb isAuthValid]) {
        NSDictionary *dic = @{@"uid" : wb.userID};
        
        SinaWeiboRequest *request = [wb requestWithURL:@"statuses/user_timeline.json" params:[dic mutableCopy] httpMethod:@"GET" delegate:self];
        request.tag = 2;
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    
    
    if (request.tag == 1) {
        _me = [UserModel yy_modelWithJSON:result];
        UserHeaderView *hView = (UserHeaderView *)_table.tableHeaderView;
        [hView setModel:_me];
    } else if (request.tag == 2) {
        //微博数组
        NSArray *array = result[@"statuses"];
        
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        
        //遍历数组
        for (NSDictionary *dic in array) {
            //创建微博对象
            WeiboModel *weiboModel = [WeiboModel yy_modelWithJSON:dic];
            
            [mArray addObject:weiboModel];
        }
        
        _weiboArray = [mArray mutableCopy];
        
        //刷新表视图
        [_table reloadData];
    }
}


#pragma mark - 表视图创建
#pragma mark - 创建表视图
- (void)createTableView {
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenwidth, kScreenheight - 64 - 49) style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
    
    
    //注册单元格
    UINib *nib = [UINib nibWithNibName:@"TableViewCell" bundle:[NSBundle mainBundle]];
    [_table registerNib:nib forCellReuseIdentifier:@"WeiboCell"];
    
    //头视图
    UIView *header = [[[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:nil options:nil] firstObject];
    CGFloat scale = kScreenwidth / header.frame.size.width;
    header.transform = CGAffineTransformMakeScale(scale, scale);
    
    _table.tableHeaderView = header;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _weiboArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell"];
    //填充微博数据
    WeiboModel *wb = _weiboArray[indexPath.row];
    //    UserModel *user = wb.user;
    
    [cell setWeibo:wb];
    
    
    return cell;
}

//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取微博对象
    WeiboModel *wb = _weiboArray[indexPath.row];
    
    //创建布局对象
    WeiboCellLauout *layout = [WeiboCellLauout layoutWithWeiboModel:wb];
    //获取高度
    return [layout cellHeight];
}


@end
