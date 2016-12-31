//
//  ViewController.m
//  PushToSetting
//
//  Created by qianjianeng on 16/4/17.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "ViewController.h"
#import "DeviceManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 100, 100, 100);
    [button setTitle:@"按钮" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"----%f-----%f", [DeviceManager availableMemory], [DeviceManager usedMemory]);
}


- (void)ButtonClick
{
        [DeviceManager goToSystemSettingPage];
    
    //    [DeviceManager goToDownloadPageInApp];
    
    //    [DeviceManager goToEvaluatePage];
    
    //    [DeviceManager goToSearchPageDependskeywords];
    
    //    [DeviceManager goToCategoryPage];
    
    //    [DeviceManager goToPaidAppPage];
    
    //    [DeviceManager goToFreeAppPage];
    
    //    [DeviceManager goToSystemSettingPage];
    
    //    [DeviceManager hideNavBarHairlineImageView:self];
    
    // [DeviceManager isHotSpotConnected];
    
    //    [DeviceManager isAllowedNotification];
    
    //    [DeviceManager hideExtraCell:[UITableView new]];
    
    //    [DeviceManager changeAccessoryViewColor:[UITableView new]];
    
    //    [DeviceManager scrollToTop];
    
    //    [DeviceManager checkAppStoreVersion];
    
    //   [DeviceManager isJailbroken];
    //    NSLog(@"---%d", [DeviceManager isJailbroken]);
    //    [DeviceManager totalDiskSpace];
    ////
    //   [DeviceManager freeDiskSpace];
    //    [DeviceManager language];
    //    
    //   [DeviceManager currentIPAddress];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
