//
//  BorderImageLoopStrategy.m
//  ScreenSnapshot
//
//  Created by Sergio Kunats on 2/8/13.
//
//

#import "BorderImageLoopStrategy.h"

@implementation BorderImageLoopStrategy

@synthesize borderWidth;

- (id) initWithColorStrategy:(ColorStrategy *)strategy {
    if ((self = [super initWithColorStrategy:strategy]))
        borderWidth = 100; // px
    return self;
}

- (void) loop:(void *)data size:(CGSize)size bpp:(unsigned short)bpp
{
    unsigned short pixelSize = sizeof(unsigned char) * bpp;
    // top
    unsigned long start = 0;
    unsigned long end = size.width * pixelSize * borderWidth;
    for (; start < end; start += pixelSize)
        [colorStrategy processPixel:(pixel_t*)&data[start]];

    // bottom
    start = (size.height - borderWidth) * size.width * pixelSize;
    end = size.width * size.height * pixelSize;
    for (; start < end; start += pixelSize)
        [colorStrategy processPixel:(pixel_t*)&data[start]];

    // left
    unsigned long startLine = borderWidth;
    unsigned long endLine = size.height - (borderWidth << 1);
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
}

@end
