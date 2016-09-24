//
//  SendWeiboViewController.m
//  weibo
//
//  Created by lushitong on 16/8/8.
//  Copyright © 2016年 mac04. All rights reserved.
//

#import "SendWeiboViewController.h"
#import "ThemButton.h"
#import "ThemeLabel.h"
#import "AppDelegate.h"
#import "LocationViewController.h"
@class ThemButton;
#define kToolViewHeight 40
#define kLocationViewHeight 20
#define kSendWeiboAPI @"statuses/update.json"
#define kSendWeiboPhotoApi @"statuses/upload.json"
#import "SinaWeibo+SendWeibo.h"
#import "EmoticonInputView.h"
@interface SendWeiboViewController ()<SinaWeiboRequestDelegate>{
    
    UITextView *_inputTextView; //输入框
    UIView *_toolView;          //工具视图
    
    //定位相关视图
    UIView *_locationView;
    UIImageView *_locationIconImageView;
    ThemeLabel *_locationNameLabel;
    ThemButton *_locationCancelButton;
    //表情选择输入框
    EmoticonInputView *_emoticonView;
    
}
@property(nonatomic,strong) NSDictionary *locationData;
@end

@implementation SendWeiboViewController
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.s
    self.title=@"发送微博";
    [self createNavigationBarButton];
    [self creatrInputView];
    [self createToolView];
    [self createLocationViews];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotification:) name:kdidTextWeibo object:nil];
    
}
#pragma -mark 接收通知的方法
- (void)receiveNotification: (NSNotification *) notification{
    
    NSLog(@"%@",notification.userInfo[@"chs"]);
    _inputTextView.text = [_inputTextView.text stringByAppendingString:notification.userInfo[@"chs"]];
    
}

#pragma -mark 视图上面的地理位置显示
- (void)createLocationViews {
    
    //创建父视图
    _locationView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 10, kLocationViewHeight)];
    //    _locationView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_locationView];
    _locationView.bottom = _toolView.top;
    
    //icon
    _locationIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kLocationViewHeight, kLocationViewHeight)];
    //    _locationIconImageView.backgroundColor = [UIColor greenColor];
    [_locationView addSubview:_locationIconImageView];
    
    //Label
    _locationNameLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(kLocationViewHeight, 0, 200, kLocationViewHeight)];
    _locationNameLabel.colorName = kMoreItemTextcolor;
    _locationNameLabel.text = @"杭州职业技术学院";
    [_locationView addSubview:_locationNameLabel];
    //Button
    _locationCancelButton = [ThemButton buttonWithType:UIButtonTypeCustom];
    _locationCancelButton.frame = CGRectMake(0, 0, kLocationViewHeight, kLocationViewHeight);
    _locationCancelButton.left = _locationNameLabel.right;
    _locationCancelButton.backgroundImageName = @"compose_toolbar_clear.png";
    [_locationView addSubview:_locationCancelButton];
    //添加点击
    [_locationCancelButton addTarget:self action:@selector(locationCancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    //默认隐藏
    _locationView.hidden = YES;
    
}
#pragma mark - Action
//取消定位
- (void)locationCancelButtonAction {
    self.locationData = nil;
}
#pragma mark - 位置信息填充
//在locationData的SET方法中 来设置显示的位置数据
- (void)setLocationData:(NSDictionary *)locationData {
    
    
    
    if (_locationData != locationData) {
        _locationData = [locationData copy];
        if (_locationData == nil) {
            _locationView.hidden = YES;
        } else {
            _locationView.hidden = NO;
            _locationNameLabel.text = _locationData[@"title"];
            [_locationIconImageView sd_setImageWithURL:[NSURL URLWithString:_locationData[@"icon"]]];
            
            //改变Label宽度
            NSDictionary *attributes = @{NSFontAttributeName : _locationNameLabel.font};
            CGRect rect = [_locationNameLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - 10 - kLocationViewHeight * 2, kLocationViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
            CGFloat width = rect.size.width;
            
            _locationNameLabel.width = width;
            _locationCancelButton.left = _locationNameLabel.right;
        }
        
        
    }
}
- (void)creatrInputView {
    _inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - kToolViewHeight)];
    //    _inputTextView.backgroundColor = [UIColor orangeColor];
    _inputTextView.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:_inputTextView];
    
    //监听键盘的改变
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [center addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)createToolView {
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kToolViewHeight)];
    _toolView.top = _inputTextView.bottom;
    NSArray *imageArray= @[@"compose_toolbar_1.png",
                           @"compose_toolbar_3.png",
                           @"compose_toolbar_4.png",
                           @"compose_toolbar_5.png",
                           @"compose_toolbar_6.png",
                           
                           ];
    //    [_toolView addSubview:button];
    for (int i = 0; i<5; i++) {
        ThemButton *button  =[ThemButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(i*kScreenWidth/5,0 , kScreenWidth/5, kToolViewHeight);
        button.imageName = imageArray[i];
        [_toolView addSubview:button];
        button.tag = i;
        
        [button addTarget:self action:@selector(toolBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [self.view addSubview:_toolView];
    
}
#pragma -mark 点击位置进入位置选择界面
- (void)toolBarButtonAction:(UIButton *)button {
    if (button.tag == 3) {
        //打开定位界面
        LocationViewController *locaiton = [[LocationViewController alloc] init];
        [locaiton addLocationResultBlock:^(NSDictionary *result) {
            
            //保存位置数据
            self.locationData = result;
        }];
        [self.navigationController pushViewController:locaiton animated:YES];
        
    }
    else if (button.tag == 4){
        
        //表情界面懒加载
        if (_emoticonView == nil) {
            _emoticonView = [[EmoticonInputView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
            
        }
        
        _inputTextView.inputView = _inputTextView.inputView ? nil : _emoticonView;
        
        //重新加载输入视图
        [_inputTextView reloadInputViews];
        //强制弹出键盘
        [_inputTextView becomeFirstResponder];
    }
}

#pragma -mark 键盘发生改变调用的事件
- (void)keyboardFrameChanged:(NSNotification *)notification {
    
    //获取键盘的状态
    //键盘改变后的结束值
    NSValue *value = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [value CGRectValue];
    
    //根据键盘的位置，来改变视图的位置
    _inputTextView.height = kScreenHeight - 64 - kToolViewHeight - keyboardFrame.size.height;
    //工具栏
    _toolView.top = _inputTextView.bottom;
    _locationView.bottom = _toolView.top;
    
}

- (void)keyboardHide:(NSNotification *)notification {
    
    _inputTextView.height = kScreenHeight - 64 - kToolViewHeight;
    _toolView.top = _inputTextView.bottom;
    _locationView.bottom = _toolView.top;
    
}
#pragma -mark 创建底部视图上的按钮

-(void)createNavigationBarButton{
    
    ThemButton *leftButton = [ThemButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame  = CGRectMake(0, 0, 64, 44);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.backgroundImageName = @"titlebar_button_9";
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    //右边
    ThemButton *rightButton = [ThemButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame  = CGRectMake(0, 0, 64, 44);
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    rightButton.backgroundImageName = @"titlebar_button_9";
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark 发送按钮和取消按钮的创建
-(void)leftButtonAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)rightButtonAction{
    NSString *text  = [_inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注意" message:@"没有微博正文" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    SinaWeibo *wb  = kSinaWeiboObject;
    NSMutableDictionary *params = [@{@"status":text}mutableCopy];
    
    if (self.locationData) {
        NSString *lon = self.locationData[@"lon"];
        NSString *lat = self.locationData[@"lat"];
        [params setObject:lon forKey:@"long"];
        [params setObject:lat forKey:@"lat"];
        
    }
    
    
    //    [wb requestWithURL:kSendWeiboAPI params:params  httpMethod:@"POST" delegate:self];
    
    
    [wb sendWeiboWithText:text image:nil params:params success:^(id result) {
        //收起键盘
        [_inputTextView resignFirstResponder];
        
        //返回前一页面
        [self dismissViewControllerAnimated:YES completion:^{
            //刷新微博
            
            NSNotification *notice = [NSNotification notificationWithName:kdidSendWeibo object:nil];
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            
        }];
    } fail:^(NSError *error) {
        NSLog(@"失败");
    }];
    
    
}

@end
