
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNImagePixelSpec.h"

@interface ImagePixel : NSObject <NativeImagePixelSpec>
#else
#import <React/RCTBridgeModule.h>

@interface ImagePixel : NSObject <RCTBridgeModule>
#endif

@end
