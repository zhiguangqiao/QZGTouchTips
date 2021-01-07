#line 1 "/Users/qiaozhiguang/Desktop/QZGTouchTips/QZGTouchTips/QZGTouchTips.xm"


#if TARGET_OS_SIMULATOR
#error Do not support the simulator, please use the real iPhone Device.
#endif
#define VIEW_SIZE (57)
#define VIEW_KEY "UIWindow-Touch-Tip-View-Key"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class UIWindow; 
static void (*_logos_orig$_ungrouped$UIWindow$sendEvent$)(_LOGOS_SELF_TYPE_NORMAL UIWindow* _LOGOS_SELF_CONST, SEL, UIEvent *); static void _logos_method$_ungrouped$UIWindow$sendEvent$(_LOGOS_SELF_TYPE_NORMAL UIWindow* _LOGOS_SELF_CONST, SEL, UIEvent *); 

#line 11 "/Users/qiaozhiguang/Desktop/QZGTouchTips/QZGTouchTips/QZGTouchTips.xm"


static void _logos_method$_ungrouped$UIWindow$sendEvent$(_LOGOS_SELF_TYPE_NORMAL UIWindow* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIEvent * event) {
    static NSMutableDictionary* _layerCacheMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _layerCacheMap = [[NSMutableDictionary alloc] init];
    });
    NSSet *touches = event.allTouches;
    for (UITouch *touch in touches) {
        CALayer *tipLayer = _layerCacheMap[[NSString stringWithFormat:@"%p", touch]];
        switch (touch.phase) {
            case UITouchPhaseBegan:
            {
                if (!tipLayer) {
                    tipLayer = [[CALayer alloc] init];
                    tipLayer.frame = CGRectMake(0, 0, VIEW_SIZE, VIEW_SIZE);
                    tipLayer.backgroundColor = [UIColor redColor].CGColor;
                    tipLayer.position = [touch locationInView:self];
                    tipLayer.cornerRadius = VIEW_SIZE/2;
                    tipLayer.masksToBounds = YES;
                    _layerCacheMap[[NSString stringWithFormat:@"%p", touch]] = tipLayer;
                    [self.layer addSublayer:tipLayer];
                }
            }
                break;
            case UITouchPhaseMoved:



                break;
            case UITouchPhaseCancelled:
            case UITouchPhaseEnded:
            {
                [tipLayer removeFromSuperlayer];
                _layerCacheMap[[NSString stringWithFormat:@"%p", touch]] = nil;
            }
                break;
            default:
                break;
        }
    }
    _logos_orig$_ungrouped$UIWindow$sendEvent$(self, _cmd, event);
}


static __attribute__((constructor)) void _logosLocalCtor_7d006fd9(int __unused argc, char __unused **argv, char __unused **envp) {
    NSLog(@"------- inject success ---------");
    {Class _logos_class$_ungrouped$UIWindow = objc_getClass("UIWindow"); { MSHookMessageEx(_logos_class$_ungrouped$UIWindow, @selector(sendEvent:), (IMP)&_logos_method$_ungrouped$UIWindow$sendEvent$, (IMP*)&_logos_orig$_ungrouped$UIWindow$sendEvent$);}}
}



