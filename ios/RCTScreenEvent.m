
#import "RCTScreenEvent.h"
#import <React/RCTUtils.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <notify.h>

NSString *com = @"com";
NSString *apple = @"apple";
NSString *spring = @"spring";
NSString *board = @"board";
NSString *lock = @"lock";
NSString *state = @"state";
NSString *complete = @"complete";

static RCTScreenEvent* screenEvent = nil;

@interface RCTScreenEvent()
@property (nonatomic, strong) NSString *eventStateString;
@property (nonatomic, strong) NSString *eventCompleteString;
@end

@implementation RCTScreenEvent

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE(ScreenEvent);

- (NSString *)eventStateString {
    if (!_eventStateString) {
        _eventStateString = [NSString stringWithFormat:@"%@.%@.%@%@.%@%@",com,apple,spring,board,lock,state];
    }
    return _eventStateString;
}

- (NSString *)eventCompleteString {
    if (!_eventCompleteString) {
        _eventCompleteString = [NSString stringWithFormat:@"%@.%@.%@%@.%@%@",com,apple,spring,board,lock,complete];
    }
    return _eventCompleteString;
}

RCT_EXPORT_METHOD(create)
{
    screenEvent = self;
    //注册事件
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, screenLockStateChanged, (CFStringRef)self.eventCompleteString, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, screenLockStateChanged, (CFStringRef)self.eventStateString, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

RCT_EXPORT_METHOD(destroy)
{
    screenEvent = nil;
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFStringRef)self.eventCompleteString, NULL);
    CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFStringRef)self.eventStateString, NULL);
}

static void screenLockStateChanged(CFNotificationCenterRef center,void* observer,CFStringRef name,const void* object,CFDictionaryRef userInfo)
{
    NSString *com = @"com";
    NSString *apple = @"apple";
    NSString *spring = @"spring";
    NSString *board = @"board";
    NSString *lock = @"lock";
    NSString *complete = @"complete";
    NSString *str = [NSString stringWithFormat:@"%@.%@.%@%@.%@%@",com,apple,spring,board,lock,complete];
    NSString* lockstate = (__bridge NSString*)name;
    if ([lockstate isEqualToString:str]) {
        NSLog(@"======================locked.");
        // 此处监听的系统锁屏
    } else {
        NSLog(@"======================lock state changed.");
        // 此处监听到屏幕解锁事件（锁屏也会掉用此处一次，锁屏事件要在上面实现）
        if (screenEvent) {
            [screenEvent.bridge.eventDispatcher sendAppEventWithName:@"com.ronbell.luna.lock.state"  body:nil];
        }
    }
}
@end
