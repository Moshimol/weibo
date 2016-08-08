//
//  MoreViewController.m
//  weibo
//
//  Created by lushitong on 16/7/29.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "MoreViewController.h"
#import "AppDelegate.h"
@class ThemeManager;
@interface MoreViewController ()
@property (weak, nonatomic) IBOutlet UILabel *thisThem;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    
    ThemeImage *bgImageView = [[ThemeImage alloc]initWithFrame:self.view.bounds];
    bgImageView.imageName =@"bg_detail.jpg";
    [self.view insertSubview:bgImageView atIndex:0];
    _icon1.imageName=@"more_icon_account";
    _icon2.imageName=@"more_icon_feedback";
    _icon3.imageName=@"more_icon_draft";
    _icon4.imageName=@"more_icon_about";
    
    _label1.colorName= kMoreItemTextcolor;
    _lable2.colorName= kMoreItemTextcolor;
    _lable2.colorName= kMoreItemTextcolor;
    _lable3.colorName= kMoreItemTextcolor;
    _lable4.colorName= kMoreItemTextcolor;
    _lable5.colorName= kMoreItemTextcolor;
    _lable6.colorName= kMoreItemTextcolor;
//    self.tableView.separatorColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutAction:(id)sender {
    NSLog(@"登录succes");
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate logoutWeibo];
}
#pragma -mark 清理缓存
- (void)viewWillAppear:(BOOL)animated
{
    
    ThemeManager *manager = [ThemeManager shareManager];
    
    _thisThem.text = manager.currentThemeName;
    
    [super viewWillAppear:animated];
    [self readCacheSize];
}

- (void)clearCache
{
    //    [[SDImageCache sharedImageCache] clearDisk];
    NSString *cache = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    [[NSFileManager defaultManager] removeItemAtPath:cache error:NULL];
    
}

- (void)readCacheSize
{
    NSUInteger size = [self getCacheData];
    
    double mbSize = size / 1024.0 / 1024.0;
    _sizeLabel.text = [NSString stringWithFormat:@"%.2fMB", mbSize];
}

- (NSUInteger )getCacheData
{
    
    NSUInteger size = 0;
    //1、简单方法
    //    NSUInteger size = [[SDImageCache sharedImageCache] getSize];
    //找到缓存路径
    NSString *cache = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    //文件枚举 获取当前路径下所有文件的属性
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:cache];
    
    //拿到文件夹里面的所有文件
    for (NSString *fileName in fileEnumerator) {
        //获取所有文件的路径
        NSString *filePath = [cache stringByAppendingPathComponent:fileName];
        //获取所有文件的属性
        NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:NULL];
        //计算每个文件的大小
        //计算总共文件的大小
        size += [dic fileSize];
    }
    
    return size;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 1) {
        
        
        
        
        NSUInteger size = [self getCacheData];
        if (size==0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你的缓冲还要清理吗？" message:[NSString stringWithFormat:@"缓存为0M，不需要清理"] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:NULL]];
            [self presentViewController:alert animated:YES completion:NULL];
            
        }
        else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除缓存" message:[NSString stringWithFormat:@"确定清除缓存%@", self.sizeLabel.text] preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self clearCache];
                [self readCacheSize];
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL]];
            
            [self presentViewController:alert animated:YES completion:NULL];
        }
    }
    NSLog(@"%li  %li",indexPath.row,indexPath.section);
}


@end
