//
//  LeftViewController.m
//  weibo
//
//  Created by lushitong on 16/8/1.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSArray *numberArray;
    UITableView *_tableView;
    UIColor *_textColor;
    NSInteger _indexSelext;
}
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"设置";
    ThemeImage *bgImageView = [[ThemeImage alloc]initWithFrame:self.view.bounds];
    bgImageView.imageName =@"mask_bg.jpg";
    [self.view insertSubview:bgImageView atIndex:0];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:kThemeChangeNoticficationName object:nil];
    
    [self createTableView];
    _indexSelext = 0;
    
}
-(void)createTableView{
    numberArray = @[@"无",@"滑动",@"滑动&缩放",@"3D旋转",@"视觉滑动"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 180, kScreenheight-64) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.backgroundColor  = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
}
-(void)themeChange{
    _textColor =[[ThemeManager shareManager]setColorWithName:kMoreItemTextcolor];
    
    _tableView.separatorColor = _textColor;
    [_tableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return numberArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThemeManager *manager = [ThemeManager shareManager];
    NSDictionary *allThemes = manager.allThemes;
    //获取所有主题的主题名
    NSArray *allNames = allThemes.allKeys;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.textLabel.text = numberArray[indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = _textColor;
    
    NSString *key = allNames[indexPath.row];
    NSString *imageName = [NSString stringWithFormat:@"%@/%@", allThemes[key], @"more_icon_theme.png"];
    UIImage *image = [UIImage imageNamed:imageName];
    cell.imageView.image = image;
    
    
    if (indexPath.row == _indexSelext) {
        cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    _indexSelext = indexPath.row;
    [_tableView reloadData];
    
    MMExampleDrawerVisualStateManager *manage = [MMExampleDrawerVisualStateManager sharedManager];
    manage.leftDrawerAnimationType = indexPath.row;
    manage.rightDrawerAnimationType= indexPath.row;
    
    NSLog(@"你选择了%li",indexPath.row);
}

@end
