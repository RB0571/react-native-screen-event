
#import "RCTScreenEvent.h"
#import <React/RCTUtils.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <notify.h>

#define NotificationLock CFSTR("com.apple.springboard.lockcomplete")
#define NotificationChange CFSTR("com.apple.springboard.lockstate")
#define NotificationPwdUI CFSTR("com.apple.springboard.hasBlankedScreen")

static RCTScreenEvent* screenEvent = nil;

@interface RCTScreenEvent()

@end

@implementation RCTScreenEvent

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE(ScreenEvent);


RCT_EXPORT_METHOD(create)
{
    screenEvent = self;
    //注册事件
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, screenLockStateChanged, NotificationLock, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, screenLockStateChanged, NotificationChange, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

RCT_EXPORT_METHOD(destroy)
{
    screenEvent = nil;
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, NotificationLock, NULL);
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, NotificationChange, NULL);
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
        if (screenEvent) {
            [screenEvent.bridge.eventDispatcher sendAppEventWithName:@"com.apple.springboard.lockstate"  body:nil];
        }
    }
}
@end
