//
//  FMMemoryTip.m
//  PushToSetting
//
//  Created by qianjn on 2016/12/31.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "FMMemoryTip.h"
#import<sys/sysctl.h>
#import<mach/mach.h>


#define k_memory_tip_Width 60

@interface FMMemoryTip ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *allMemoryLabel;
@property (nonatomic, strong) UILabel *usedMemoryLabel;
@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic) BOOL dragEnable;
@end

@implementation FMMemoryTip

+(instancetype)getInstance
{
    static id shareInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate,^{
#ifdef DEBUG
        shareInstance = [[self alloc]init];
#endif
    });
    return shareInstance;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - k_memory_tip_Width, 0, k_memory_tip_Width, k_memory_tip_Width)];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkMemory) userInfo:nil repeats:YES];
    self.backgroundColor = [UIColor blueColor];
    self.layer.cornerRadius = self.bounds.size.width/2;
    self.layer.masksToBounds = YES;
    
    _allMemoryLabel = [[UILabel alloc] init];
    _allMemoryLabel.font = [UIFont systemFontOfSize:10];
    _allMemoryLabel.textColor = [UIColor blackColor];
    
    _allMemoryLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_allMemoryLabel];
    
    _usedMemoryLabel = [[UILabel alloc] init];
    _usedMemoryLabel.font = [UIFont systemFontOfSize:10];
    _usedMemoryLabel.textColor = [UIColor blackColor];
    
    _usedMemoryLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_usedMemoryLabel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    });
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _allMemoryLabel.center = CGPointMake(k_memory_tip_Width/2, k_memory_tip_Width/2 - 8);
    _usedMemoryLabel.center = CGPointMake(k_memory_tip_Width/2, k_memory_tip_Width/2 + 8);
    
}

//当前设备可用内存
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

// 获取当前应用所占用的内存（单位：MB）
- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

- (void)checkMemory
{
    _allMemoryLabel.text = [NSString stringWithFormat:@"T:%.1f M", [self availableMemory]];
    _usedMemoryLabel.text = [NSString stringWithFormat:@"C:%.1f M", [self usedMemory]];
    [_allMemoryLabel sizeToFit];
    [_usedMemoryLabel sizeToFit];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    _beginPoint = [touch locationInView:self];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - _beginPoint.x;
    float offsetY = nowPoint.y - _beginPoint.y;
    
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil ;
}
@end
