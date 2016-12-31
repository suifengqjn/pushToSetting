//
//  DeviceManager.h
//  PushToSetting
//
//  Created by qianjianeng on 16/4/17.
//  Copyright © 2016年 SF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#import <ifaddrs.h>
#import <arpa/inet.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/ioctl.h>

@class ViewController;

@protocol OpenAppStoreDelegate <NSObject>

-(void)openAppStore:(UIViewController *)controller;

@end





@interface DeviceManager : NSObject



@property(nonatomic,weak) id<OpenAppStoreDelegate> delegate;

+(DeviceManager *)shareInstance;


//-------APPStore---------//

+(void)goToDownloadPageOutApp;         //AppStore下载页

+(void)goToDownloadPageInApp;          //应用内打开下载页

+(void)goToEvaluatePage;               //评论页

+(void)goToSearchPageDependskeywords;  //关键词搜索页

+(void)goToCategoryPage;               //分类页

+(void)goToPaidAppPage;                //付费应用页

+(void)goToFreeAppPage;                //免费应用页



//-------系统设置---------//

// IOS 8 跳转到当前app的设置页面
+(void)goToSystemSettingPage;          //系统设置页

//wifi列表
+(void)gotoWifiList;
//关于本机
+ (void)gotoAbout;
//Accessibility 辅助功能
+ (void)gotoAccessibility;
//通用
+ (void)gotoGeneral;
//定位服务
+(void)gotoWifiLocation;

//FaceTime设置
+(void)gotoFaceTimeSetting;

//音乐设置界面
+(void)gotoMusicSetting;

//墙纸设置界面
+(void)gotoWallPaperSetting;

//蓝牙设置界面
+(void)gotoBluetoothSetting;

//iCloud设置界面
+(void)gotoiCloudSetting;

//Safari设置
+(void)gotoSafariSetting;

//通知设置
+(void)gotoNotification;

//照片与相机
+(void)gotoCamera;

//电话
+(void)gotoPhone;

//判断是否存在热点栏
+(void)isHotSpotConnected;

//是否允许推送;
+(BOOL)isAllowedNotification;



//-------手机信息---------//
+(void)checkAppStoreVersion;          //获取appstore上应用版本

+(BOOL)isJailbroken;                  //设备是否越狱

+ (NSString *)totalDiskSpace;         //总的磁盘空间

+ (NSString *)freeDiskSpace ;         //剩余磁盘空间

+ (void)language;                     //获取系统语言

+ (NSString *)currentIPAddress;       //获取当前ip地址



//-------other---------//
+(void)hideNavBarHairlineImageView:(UIViewController *)controller;    //隐藏导航栏下得分割线

+(void)hideExtraCell:(UITableView *)tableView;                        //tableView隐藏多余的cell

+(void)changeAccessoryViewColor:(UITableView *)tabeView;              //修改cell上accessoryView的颜色

+(void)scrollToTop;                                                   //点击状态栏滚动到顶部


+ (double)availableMemory;
+ (double)usedMemory;


@end
