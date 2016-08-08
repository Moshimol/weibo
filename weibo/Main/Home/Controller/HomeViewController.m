//
//  HomeViewController.m
//  weibo
//
//  Created by lushitong on 16/7/29.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "ThemeImage.h"
#define kGetTimeWeibo @"statuses/home_timeline.json"
#import "UIViewController+MMDrawerController.h"
#import "WeiboModel.h"
#import "UserModel.h"
#import "YYModel.h"
#import "TableViewCell.h"
#import "WeiboCellLauout.h"
#import "WXRefresh.h"
#import <AVFoundation/AVFoundation.h>
#import "RegexKitLite.h"
@class WeiboCellLauout;
@interface HomeViewController ()<SinaWeiboRequestDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *_Weiboarray;
    UITableView *_table;
    
    ThemeImage *_newheadView;
    UILabel *_newWeiboCountLabel;
    SystemSoundID _msgID;
}

@end

@implementation HomeViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self loadWeiboData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Moshimol";
    self.view.backgroundColor= [UIColor clearColor];
    [self creatTableView];
    UINib *nib = [UINib nibWithNibName:@"TableViewCell" bundle:[NSBundle mainBundle]];
    [_table registerNib:nib forCellReuseIdentifier:@"WeiboCell"];
    
    
    
    //-------------------------------系统自带的下来加载-------------------------------
    //    UIRefreshControl *resh =  [[UIRefreshControl alloc]init];
    //    
    //    [resh addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    //    [_table addSubview:resh];
    //-------------------------------使用框架进行加载-------------------------------
    
    NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"msgcome" withExtension:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &_msgID);
    
    //发送通知
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(didSendWeibo) name:kdidSendWeibo object:nil];
}
#pragma -mark 消息接收


-(void)didSendWeibo{
    NSLog(@"微博刷新服务开启");
    [_table.pullToRefreshView startAnimating];
    [self loadNewData];
    
}
//-(void)refreshAction:(UIRefreshControl *)refresh {
//    
//    NSAttributedString *string = [[NSAttributedString alloc]initWithString:@"shuanxin "];
//    refresh.attributedTitle = string;
//    //    [_table reloadData];
//    [refresh performSelector:@selector(endRefreshing) withObject:nil afterDelay:2];
//    [refresh performSelector:@selector(reloadData) withObject:nil afterDelay:2];
//}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    AudioServicesRemoveSystemSoundCompletion(_msgID);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark
-(void)loadWeiboData{
    
    SinaWeibo *weibo = kSinaWeiboObject;
    if (![weibo isAuthValid]) {
        [weibo logIn];
        return;
    }
    NSDictionary *params =@{@"count" : @"20"};
    SinaWeiboRequest *requesst =[weibo requestWithURL:kGetTimeWeibo
                                               params:[params mutableCopy]
                                           httpMethod:@"GET"
                                             delegate:self];
    
    requesst.tag= 0;
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result;
{
    NSArray *array = result[@"statuses"];
    
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    
    //遍历数组
    for (NSDictionary *dic in array) {
        //创建微博对象
        WeiboModel *weiboModel = [WeiboModel yy_modelWithJSON:dic];
        
        [mArray addObject:weiboModel];
        
        
    }
    
    
    if (request.tag == 0) {
        _Weiboarray = [mArray mutableCopy];
        
    }
    else if (request.tag == 1){
        
        if (mArray.count==0) {
            [_table.pullToRefreshView stopAnimating];
            [self showNewWeiCount:0];
            return;
        }
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, mArray.count)];
        [_Weiboarray insertObjects:mArray atIndexes:indexSet];
        [_table.pullToRefreshView stopAnimating];
        [self showNewWeiCount:mArray.count];
        [self loadWeiboData];
        
    }
    else if(request.tag == 3){
        //上拉加载
        if (mArray.count==0) {
            [_table.infiniteScrollingView stopAnimating];
            return;
        }
        //        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_Weiboarray.count-1, mArray.count)];
        //        [_Weiboarray insertObjects:mArray atIndexes:indexSet];
        [mArray removeObjectAtIndex:0];
        [_Weiboarray addObjectsFromArray:mArray];
        [_table.infiniteScrollingView stopAnimating];
        
        
    }
    
    [_table reloadData];
}
//微博只能在Home这个页面进行滑动
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //...
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}

#pragma -mark 创建TableView

-(void)creatTableView{
    
    _table  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, kScreenheight-64-49) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource =self;
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
    //使用weak指针来解决循环引用
    
    __weak  HomeViewController *weakSelf = self;
    [_table addPullDownRefreshBlock:^{
        
        __strong HomeViewController *strongSelf = weakSelf;
        //-------------------------------循环应用-------------------------------
        [strongSelf loadNewData];
    }];
    
    [_table addInfiniteScrollingWithActionHandler:^{
        __strong HomeViewController *strongSelf = weakSelf;
        //-------------------------------循环应用-------------------------------
        [strongSelf loadMoreData];
        
        
    }];
    
    _newheadView = [[ThemeImage alloc]initWithFrame:CGRectMake(3, 3, kScreenwidth - 6, 40)];
    
    _newheadView.imageName=@"timeline_notify.png";
    _newheadView.transform = CGAffineTransformMakeTranslation(0, -60);
    
    
    _newWeiboCountLabel = [[UILabel alloc]initWithFrame:_newheadView.bounds];
    _newWeiboCountLabel.text=@"有8条微博";
    _newWeiboCountLabel.textAlignment = NSTextAlignmentCenter;
    [_newheadView addSubview:_newWeiboCountLabel];
    
    [self.view addSubview:_newheadView];
    
}
#pragma -mark TableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _Weiboarray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell"];
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    //    }
    //    //填充微博数据
    WeiboModel *weibo = _Weiboarray[indexPath.row];
    //    UserModel *user = wb.user;
    //    
    //    cell.textLabel.text = user.name;
    //    cell.detailTextLabel.text = wb.text;
    
    [cell setWeibo:weibo];
    
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //计算高度 并且返回相对用的高度
    WeiboModel *wb = _Weiboarray[indexPath.row];
    //    NSDictionary *attributes=@{NSFontAttributeName:kWeiboTextFont};
    //    
    //    CGRect rect = [wb.text boundingRectWithSize:CGSizeMake(kScreenwidth-20, 10000)
    //                                        options:NSStringDrawingUsesLineFragmentOrigin
    //                                     attributes:attributes
    //                                        context:nil ];
    //    CGFloat imgeHeight = wb.bmiddle_pic ? 210:0;
    //    return rect.size.height+60+10+10+imgeHeight;
    //-------------------------------计算单元格的高度 并且返回-------------------------------
    WeiboCellLauout *layout = [WeiboCellLauout layoutWithWeiboModel:wb];
    return [layout cellHeight];
    
}
#pragma -mark 加载更多的数据
-(void)loadNewData {
    //    NSLog(@"最上面的数据正在重新加载");
    //    [_table.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:2];
    //    
    
    WeiboModel *firstweibo  = [_Weiboarray firstObject];
    NSString *idstr = firstweibo.idstr;
    SinaWeibo *weibo = kSinaWeiboObject;
    if (![weibo isAuthValid]) {
        [weibo logIn];
        return;
    }
    NSDictionary *params =@{@"count" : @"20",
                            @"since_id":idstr};
    //    SinaWeiboRequest *request = 
    SinaWeiboRequest *request =[weibo requestWithURL:kGetTimeWeibo
                                              params:[params mutableCopy]
                                          httpMethod:@"GET"
                                            delegate:self];
    request.tag = 1;
    
}
-(void)loadMoreData{
    NSLog(@"最下面的视图正在加载");
    WeiboModel *firstweibo  = [_Weiboarray lastObject];
    NSString *idstr = firstweibo.idstr;
    SinaWeibo *weibo = kSinaWeiboObject;
    if (![weibo isAuthValid]) {
        [weibo logIn];
        return;
    }
    NSDictionary *params =@{@"count" : @"20",
                            @"max_id":idstr};
    //    SinaWeiboRequest *request =
    SinaWeiboRequest *request =[weibo requestWithURL:kGetTimeWeibo
                                              params:[params mutableCopy]
                                          httpMethod:@"GET"
                                            delegate:self];
    request.tag = 3;
    
}
#pragma -mark 下拉加载提示
-(void)showNewWeiCount:(NSInteger)count{
    
    if (count == 0) {
        _newWeiboCountLabel.text = @"没有新微博";
        
    }
    else{
        
        
        _newWeiboCountLabel.text = [NSString stringWithFormat:@"%li条新微博",count];
        
    }
    
    [UIView  animateWithDuration:0.25 animations:^{
        _newheadView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        AudioServicesPlaySystemSound(_msgID);
        [UIView animateWithDuration:0.5 delay:2 options:UIViewAnimationOptionLayoutSubviews animations:^{
            _newheadView.transform = CGAffineTransformMakeTranslation(0, -60);
        } completion:nil];
    }];
}
@end
