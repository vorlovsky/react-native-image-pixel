#import "ImagePixel.h"

@implementation ImagePixel

static NSMutableDictionary* images = [[NSMutableDictionary alloc] init];

RCT_EXPORT_MODULE()

RCT_REMAP_METHOD(loadImage,
                 fromPath:(NSString *)path
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (image == nil) {
        reject(@"event_failure", @"Failed to load image. Path is incorrect or image is corrupt", nil);
        return;
    }

    [images setObject:image forKey:path];
    
    NSDictionary* result = @{@"width": @(image.size.width), @"height": @(image.size.height), @"id": path};

    resolve(result);
}

RCT_REMAP_METHOD(unloadImage,
                 withId:(NSString *)id
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
    UIImage *image = [images objectForKey:id];
    if (image == nil) {
        reject(@"event_failure", @"Failed to unload image. Unknown ID", nil);
        return;
    }

    [images removeObjectForKey:id];

    resolve(nil);
}

RCT_REMAP_METHOD(getPixel,
                 withId:(NSString *)id
                 atX:(double)x
                 atY:(double)y
                 withNormalizedCoords:(BOOL)normalized
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{

    UIImage *image = [images objectForKey:id];
    if (image == nil) {
        reject(@"event_failure", @"Failed to find image. Unknown ID", nil);
        return;
    }

    int px, py;
    if(normalized) {
        px = image.size.width * x;
        py = image.size.height * y;
    } else {
        px = x;
        py = y;
    }

    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);

    int pixelInfo = ((image.size.width  * py) + px ) * 4;

    UInt8 red = data[pixelInfo];
    UInt8 green = data[(pixelInfo + 1)];
    UInt8 blue = data[pixelInfo + 2];
    UInt8 alpha = data[pixelInfo + 3];
    CFRelease(pixelData);

    NSString *hex = [NSString stringWithFormat:@"%02X%02X%02X%02X", red, green, blue, alpha];
    NSDictionary* result = @{@"r": @(red), @"g": @(green), @"b": @(blue), @"a": @(alpha / 255.0f), @"hex": hex};

    resolve(result);
}

// Don't compile this code when we build for the old architecture.
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeImagePixelSpecJSI>(params);
}
#endif

@end
