// See http://iphonedevwiki.net/index.php/Logos

#if TARGET_OS_SIMULATOR
#error Do not support the simulator, please use the real iPhone Device.
#endif
#define VIEW_SIZE (57)
#define VIEW_KEY "UIWindow-Touch-Tip-View-Key"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

%hook UIWindow
- (void)sendEvent:(UIEvent *)event
{
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
            {
                [CATransaction begin];
                [CATransaction setDisableActions:YES];
                tipLayer.position = [touch locationInView:self];
                [CATransaction commit];
            }
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
    %orig(event);
}
%end

%ctor {
    NSLog(@"------- inject success ---------");
    %init;
}



