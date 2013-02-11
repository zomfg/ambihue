//
//  BorderImageLoopStrategy.m
//  ScreenSnapshot
//
//  Created by Sergio Kunats on 2/8/13.
//
//

#import "BorderImageLoopStrategy.h"

dispatch_queue_t queue = NULL;

@implementation BorderImageLoopStrategy

@synthesize borderWidth;

- (id) initWithColorStrategy:(ColorStrategy *)strategy {
    if ((self = [super initWithColorStrategy:strategy]))
        borderWidth = 100; // px
    return self;
}

- (void) loop:(void *)data size:(CGSize)size bpp:(unsigned short)bpp
{
    if (queue == NULL)
        queue = dispatch_queue_create("com.hue.loop.border", 0);
    if (borderWidth << 1 > MIN(size.height, size.width))
        borderWidth = MIN(size.height, size.width) / 2;
    __block unsigned short pixelSize = sizeof(unsigned char) * bpp;
    // top
    __block unsigned long start = 0;
    __block unsigned long end = size.width * pixelSize * borderWidth;
//    dispatch_async(queue, ^{
        for (; start < end; start += pixelSize)
            [colorStrategy processPixel:(pixel_t*)&data[start]];

        // bottom
        start = (size.height - borderWidth) * size.width * pixelSize;
        end = size.width * size.height * pixelSize;
        for (; start < end; start += pixelSize)
            [colorStrategy processPixel:(pixel_t*)&data[start]];
//    });

    // left
    __block unsigned long startLine = borderWidth;
    __block unsigned long endLine = size.height - (borderWidth << 1);
//    dispatch_async(queue, ^{
    for (; startLine < endLine; ++startLine) {
        start = startLine * size.width * pixelSize;
        end = start + borderWidth * pixelSize;
        for (; start < end; start += pixelSize)
            [colorStrategy processPixel:(pixel_t*)&data[start]];
    }

    // right
    for (; startLine < endLine; ++startLine) {
        start = (startLine * size.width + (size.width - borderWidth)) * pixelSize;
        end = start + borderWidth * pixelSize;
        for (; start < end; start += pixelSize)
            [colorStrategy processPixel:(pixel_t*)&data[start]];
    }
//    });
//    dispatch_sync(queue, ^{[self done];});
    [self done];
}

@end
