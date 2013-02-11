//
//  ImageLoopStrategy.m
//  ScreenSnapshot
//
//  Created by Sergio Kunats on 2/8/13.
//
//

#include "stuff.h"
#import "ImageLoopStrategy.h"
CGContextRef CreateARGBBitmapContext (CGImageRef inImage, unsigned char p2scale);

CGContextRef CreateARGBBitmapContext(CGImageRef inImage, unsigned char p2scale)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    size_t          bitmapByteCount;
    size_t          bitmapBytesPerRow;

    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage) >> p2scale;
    size_t pixelsHigh = CGImageGetHeight(inImage) >> p2scale;

    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);

    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }

    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }

    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     CGImageGetAlphaInfo(inImage));
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }

    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );

    return context;
}

void* GetImageBytes(const CGImageRef inImage, const unsigned short p2scale, CGSize *size, unsigned short *bpp);
void* GetImageBytes(const CGImageRef inImage, const unsigned short p2scale, CGSize *size, unsigned short *bpp)
{
    // size / 2^p2scale
    CGContextRef cgctx = CreateARGBBitmapContext(inImage, p2scale);
    if (cgctx == NULL)
        // error creating context
        return NULL;
    *bpp = CGImageGetBitsPerPixel(inImage) / CGImageGetBitsPerComponent(inImage);
    
    // Get image width, height. We'll use the entire image.
    size->width  = CGImageGetWidth(inImage) >> p2scale;
    size->height = CGImageGetHeight(inImage) >> p2scale;
    CGRect rect = {{0,0},{size->width,size->height}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    void *data = CGBitmapContextGetData(cgctx);
    // When finished, release the context
    CGContextRelease(cgctx);
    return data;
}

@implementation ImageLoopStrategy

@synthesize colorStrategy, onComplete;

- (void) loop:(void *)data size:(CGSize)size bpp:(unsigned short)bpp
{
    NSLog(@"LOOPTY LOOP");
    [self done];
}

- (void) done {
//    NSLog(@"DONE");
    if (onComplete == nil)
        return;
//    NSLog(@"IM SO GONNA COMPLETE");
    dispatch_async(dispatch_get_main_queue(), ^{
        onComplete(colorStrategy.HSVColor, colorStrategy.RGBColor);
    });
}

- (id) initWithColorStrategy:(ColorStrategy*)strategy {
    if ((self = [self init])) {
        colorStrategy = strategy;
        onComplete = nil;
    }
    return self;
}

- (void) processImage:(CGImageRef)inImage {
    // Create the bitmap context
//    static dispatch_queue_t queue = NULL;
//    if (queue == NULL)
//        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
//    dispatch_async(queue, ^{
    CGSize size;
    unsigned short bpp;
    void *data = GetImageBytes(inImage, 1, &size, &bpp);
    if (data != NULL)
    {
        [colorStrategy reset];
        [self loop:data size:size bpp:bpp];
        free(data);
    }
//    }); // dispatch block
}
@end
