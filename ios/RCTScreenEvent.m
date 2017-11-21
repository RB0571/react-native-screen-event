
#import "RCTScreenEvent.h"
#import <React/RCTUtils.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <notify.h>

#define NotificationLock CFSTR("com.apple.springboard.lockcomplete")
#define NotificationChange CFSTR("com.apple.springboard.lockstate")
#define NotificationPwdUI CFSTR("com.apple.springboard.hasBlankedScreen")

@interface RCTScreenEvent()

@end

@implementation RCTScreenEvent

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE(ScreenEvent);


RCT_EXPORT_METHOD(create)
{
    //注册事件
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, screenLockStateChanged, NotificationLock, (const void*)NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, screenLockStateChanged, NotificationChange, (const void*)NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

RCT_EXPORT_METHOD(destroy)
{
    
    
}

static void screenLockStateChanged(CFNotificationCenterRef center,void* observer,CFStringRef name,const void* object,CFDictionaryRef userInfo)
{
    NSString* lockstate = (__bridge NSString*)name;
    if ([lockstate isEqualToString:(__bridge  NSString*)NotificationLock]) {
        NSLog(@"======================locked.");
        // 此处监听的系统锁屏
    } else {
        NSLog(@"======================lock state changed.");
        // 此处监听到屏幕解锁事件（锁屏也会掉用此处一次，锁屏事件要在上面实现）
        [appDelegate.eventEmitter sendEventWithName:@"com.apple.springboard.lockstate" body:nil];
    }
}
@end
