//
//  ThemSelectController.m
//  weibo
//
//  Created by lushitong on 16/7/31.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "ThemSelectController.h"
#import "ThemeManager.h"


@interface ThemSelectController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *_table;
    UIColor *_textColor;
}
@end

@implementation ThemSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    [self tableViewCreate];
    _table.backgroundColor= [UIColor clearColor];
    //监听通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:kThemeChangeNoticficationName object:nil];
}
-(void)themeChange{
    _textColor =[[ThemeManager shareManager]setColorWithName:kMoreItemTextcolor];
    
    _table.separatorColor = _textColor;
    [_table reloadData];
    
}
-(void)tableViewCreate{
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenwidth, kScreenheight-64) style:UITableViewStylePlain];
    [self.view addSubview:_table];
    
    _table.dataSource = self;
    _table.delegate = self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [ThemeManager shareManager].allThemes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ThemeManager *manager = [ThemeManager shareManager];
    NSDictionary *allThemes = manager.allThemes;
    //获取所有主题的主题名
    NSArray *allNames = allThemes.allKeys;
    //创建单元格
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        
    }
    cell.backgroundColor = [UIColor clearColor];
    NSString *key = allNames[indexPath.row];
    cell.textLabel.text = key;
    cell.textLabel.textColor=_textColor;
    //图片
    //more_icon_theme.png
    NSString *imageName = [NSString stringWithFormat:@"%@/%@", allThemes[key], @"more_icon_theme.png"];
    UIImage *image = [UIImage imageNamed:imageName];
    cell.imageView.image = image;
    
    
    
    if ([key isEqualToString:manager.currentThemeName]) {
        
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"你选择了%li个",indexPath.row);
    
    
    
    ThemeManager *manager = [ThemeManager shareManager];
    
    NSDictionary *dic= manager.allThemes;
    NSArray *array = dic.allKeys;
    
    
    NSString *string = array[indexPath.row];
    
    manager.currentThemeName =string;
    
    
    [_table reloadData];
    //    NSLog(@"%@",array);
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
