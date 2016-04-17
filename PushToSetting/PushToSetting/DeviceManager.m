//
//  DeviceManager.m
//  PushToSetting
//
//  Created by qianjianeng on 16/4/17.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "DeviceManager.h"
#import "TopWindow.h"

#define KAppID  @"1056909503"
#define MB (1024*1024)
#define GB (MB*1024)


@implementation DeviceManager

+(DeviceManager *)shareInstance{
    
    static id shareInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate,^{
        shareInstance = [[self alloc]init];
    });
    return shareInstance;
}


#pragma mark - 跳转到appStore

+(void)goToDownloadPageOutApp{
    
    //通过链接生成二维码时需使用https://itunes.apple.com/us/app/id%@?mt=8
    
    //    NSString *urlString = [NSString stringWithFormat:
    //                           @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",
    //                           KAppID];
    
    NSString *urlString = [NSString stringWithFormat:
                           @"https://itunes.apple.com/us/app/id%@?mt=8",
                           KAppID];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

+(void)goToDownloadPageInApp{
    
    NSDictionary *parameters = @{ SKStoreProductParameterITunesItemIdentifier:KAppID };
    
    Class isAllow = NSClassFromString(@"SKStoreProductViewController");
    
    if (isAllow != nil) {
        
        SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
        
        [storeProductViewController setDelegate:(id)[DeviceManager
                                                     shareInstance].delegate];
        
        [[DeviceManager shareInstance].delegate openAppStore:storeProductViewController];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [storeProductViewController loadProductWithParameters:parameters
                                              completionBlock:^(BOOL result, NSError *error){
                                                  
                                                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                  
                                              }];}
}

+(void)goToEvaluatePage{
    
    NSString *urlString = [NSString stringWithFormat:
                           @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",
                           KAppID];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

+(void)goToSearchPageDependskeywords{
    
    NSString *str = [NSString stringWithFormat:
                     @"https://itunes.apple.com/WebObjects/MZStore.woa/wa/search?mt=8&submit=edit&term=%@",
                     [@"比牛" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+(void)goToCategoryPage{
    
    /*
     教育: https://itunes.apple.com/cn/genre/ios-jiao-yu/id6017?mt=8
     游戏: https://itunes.apple.com/cn/genre/ios-you-xi/id6014?mt=8
     体育: https://itunes.apple.com/cn/genre/ios-ti-yu/id6004?mt=8
     ...
     */
    NSString *urlString = [NSString stringWithFormat:
                           @"https://itunes.apple.com/cn/genre/ios-you-xi/id6014?mt=8"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
}

+(void)goToPaidAppPage{
    
    NSString *urlString = [NSString stringWithFormat:
                           @"https://www.apple.com/cn/itunes/charts/paid-apps/"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

+(void)goToFreeAppPage{
    
    NSString *urlString = [NSString stringWithFormat:
                           @"https://www.apple.com/cn/itunes/charts/free-apps/"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

//获取appstore上应用版本
+(void)checkAppStoreVersion{
    
    //    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    NSString *URL = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",KAppID];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:URL]];
    
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponse = nil;
    
    NSError *error = nil;
    
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    //    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length]encoding:NSUTF8StringEncoding];
    
    NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:recervedData options:NSJSONReadingMutableContainers error:nil];;
    
    NSLog(@"info=%@",infoDic);
    
    NSArray *infoArray = [infoDic objectForKey:@"results"];
    
    if ([infoArray count]) {
        
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        NSLog(@"lastVersion=%@",lastVersion);
    }
}

#pragma mark - 系统设置
//About — prefs:root=General&path=About
//Accessibility — prefs:root=General&path=ACCESSIBILITY
//Airplane Mode On — prefs:root=AIRPLANE_MODE
//Auto-Lock — prefs:root=General&path=AUTOLOCK
//Brightness — prefs:root=Brightness
//Bluetooth — prefs:root=General&path=Bluetooth
//Date & Time — prefs:root=General&path=DATE_AND_TIME
//FaceTime — prefs:root=FACETIME
//General — prefs:root=General
//Keyboard — prefs:root=General&path=Keyboard
//iCloud — prefs:root=CASTLE
//iCloud Storage & Backup — prefs:root=CASTLE&path=STORAGE_AND_BACKUP
//International — prefs:root=General&path=INTERNATIONAL
//Location Services — prefs:root=LOCATION_SERVICES
//Music — prefs:root=MUSIC
//Music Equalizer — prefs:root=MUSIC&path=EQ
//Music Volume Limit — prefs:root=MUSIC&path=VolumeLimit
//Network — prefs:root=General&path=Network
//Nike + iPod — prefs:root=NIKE_PLUS_IPOD
//Notes — prefs:root=NOTES
//Notification — prefs:root=NOTIFICATIONS_ID
//Phone — prefs:root=Phone
//Photos — prefs:root=Photos
//Profile — prefs:root=General&path=ManagedConfigurationList
//Reset — prefs:root=General&path=Reset
//Safari — prefs:root=Safari
//Siri — prefs:root=General&path=Assistant
//Sounds — prefs:root=Sounds
//Software Update — prefs:root=General&path=SOFTWARE_UPDATE_LINK
//Store — prefs:root=STORE
//Twitter — prefs:root=TWITTER
//Usage — prefs:root=General&path=USAGE
//VPN — prefs:root=General&path=Network/VPN
//Wallpaper — prefs:root=Wallpaper
//Wi-Fi — prefs:root=WIFI

//系统设置
+(void)goToSystemSettingPage{
    
    //需要定位服务、相机权限等 会跳转至应用设置页面 否则跳转至系统设置页
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    [[UIApplication sharedApplication] openURL:url];
}

//关于本机
+ (void)gotoAbout
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=General&path=About"];
    [[UIApplication sharedApplication] openURL:url];
    
}

//Accessibility 辅助功能
+ (void)gotoAccessibility
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=General&path=ACCESSIBILITY"];
    [[UIApplication sharedApplication] openURL:url];
    
}

//通用
+ (void)gotoGeneral
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=General"];
    [[UIApplication sharedApplication] openURL:url];
    
}

//wifi列表
+(void)gotoWifiList
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
    [[UIApplication sharedApplication] openURL:url];
}

//定位服务
+(void)gotoWifiLocation
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
    [[UIApplication sharedApplication] openURL:url];
}

//FaceTime设置
+(void)gotoFaceTimeSetting
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=FACETIME"];
    [[UIApplication sharedApplication] openURL:url];
}

//音乐设置界面
+(void)gotoMusicSetting
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=MUSIC"];
    [[UIApplication sharedApplication] openURL:url];
}

//墙纸设置界面
+(void)gotoWallPaperSetting
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=Wallpaper"];
    [[UIApplication sharedApplication] openURL:url];
}

//蓝牙设置界面
+(void)gotoBluetoothSetting
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
    [[UIApplication sharedApplication] openURL:url];
}
//iCloud设置界面
+(void)gotoiCloudSetting
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=CASTLE"];
    [[UIApplication sharedApplication] openURL:url];
}

//Safari设置
+(void)gotoSafariSetting
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=Safari"];
    [[UIApplication sharedApplication] openURL:url];
}

//通知设置
+(void)gotoNotification
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];
    [[UIApplication sharedApplication] openURL:url];
}

//照片与相机
+(void)gotoCamera
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=Photos"];
    [[UIApplication sharedApplication] openURL:url];
}

+ (void)gotoPhone
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=Phone"];
    
    [[UIApplication sharedApplication] openURL:url];
}
//判断是否存在热点栏
+(void)isHotSpotConnected
{
    CGFloat height = [UIApplication sharedApplication].statusBarFrame.size.height;
    if (height == 40) {
        NSLog(@"存在热点");
    }
}

//是否允许推送;
+(BOOL)isAllowedNotification
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if(UIUserNotificationTypeNone != setting.types) {
            
            return YES;
        }
    }
    NSLog(@"不允许推送");
    return NO;
}


//-------other---------//

//隐藏导航栏下得分割线
bool hide;
+(void)hideNavBarHairlineImageView:(UIViewController *)controller{
    
    //一:UINavigationBar+Addition
    
    
    //二：
    //    [controller.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //
    //     controller.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    
    //三
    hide ^= 1;
    [controller.navigationController.navigationBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[UIImageView class]]) {
            
            obj.clipsToBounds = hide && 1;
        }
    }];
    
}


+(void)hideExtraCell:(UITableView *)tableView{
    
    tableView.tableFooterView = [[UIView alloc] init];
}

+(void)changeAccessoryViewColor:(UITableView *)tabeView{
    
    tabeView.tintColor = [UIColor redColor]; //acessoryview
}

+(void)scrollToTop;{
    
    //    解决点击状态栏时ScrollView自动滚动到初始位置失效办法
    [TopWindow show];
    
}


#pragma mark - 手机信息

//设备是否越狱
+ (BOOL)isJailbroken {
    
    FILE *f = fopen("/bin/bash", "r");
    BOOL isJailbroken = NO;
    if (f != NULL)
        isJailbroken = YES;
    else
        isJailbroken = NO;
    
    fclose(f);
    
    return isJailbroken;
}

+ (NSString *)memoryFormatter:(long long)diskSpace {
    NSString *formatted;
    double bytes = 1.0 * diskSpace;
    double megabytes = bytes / MB;
    double gigabytes = bytes / GB;
    if (gigabytes >= 1.0)
        formatted = [NSString stringWithFormat:@"%.2f GB", gigabytes];
    else if (megabytes >= 1.0)
        formatted = [NSString stringWithFormat:@"%.2f MB", megabytes];
    else
        formatted = [NSString stringWithFormat:@"%.2f bytes", bytes];
    NSLog(@"fotmatted=%@",formatted);
    
    return formatted;
}
//总的磁盘空间
+ (NSString *)totalDiskSpace {
    
    long long space = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemSize] longLongValue];
    return [self memoryFormatter:space];
}
//剩余磁盘空间
+ (NSString *)freeDiskSpace {
    
    long long freeSpace = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemFreeSize] longLongValue];
    return [self memoryFormatter:freeSpace];
}

//获取系统语言
+ (void)language {
    
    //语言
    NSLog(@"language=%@",[[NSLocale preferredLanguages] objectAtIndex:0]);
    
    //时区
    NSLog(@"timezone=%@",[[NSTimeZone systemTimeZone] name]);
    
    //国家
    NSLog(@"country=%@",[[NSLocale currentLocale] localeIdentifier]);
    
    //设备名称
    NSLog(@"country=%@",[[UIDevice currentDevice] name]);
    //
    NSLog(@"country=%@",[[UIDevice currentDevice] systemName]);
    
    NSLog(@"country=%@",[[UIDevice currentDevice] localizedModel]);
    
    NSLog(@"country=%@",[[UIDevice currentDevice] model]);
    //系统版本
    NSLog(@"country=%@",[[UIDevice currentDevice] systemVersion]);
    //唯一标识符，
    NSLog(@"country=%@",[[UIDevice currentDevice] identifierForVendor]);
}

//获取当前ip地址
+ (NSString *)currentIPAddress {
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if([name isEqualToString:@"en0"])
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                else
                    if([name isEqualToString:@"pdp_ip0"])
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    
    NSLog(@"addr=%@",addr);
    
    return addr ? addr : @"0.0.0.0";
}





@end
