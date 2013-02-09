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
    // top
    unsigned long start = 0;
    unsigned long end = size.width * bpp * borderWidth;
    for (; start < end; start += bpp)
        [colorStrategy processPixel:(pixel_t*)&data[start]];

    // bottom
    start = (size.height - borderWidth) * size.width * bpp;
    end = size.width * size.height * bpp;
    for (; start < end; start += bpp)
        [colorStrategy processPixel:(pixel_t*)&data[start]];

    // left
    unsigned long startLine = borderWidth;
    unsigned long endLine = size.height - borderWidth * 2;
    for (; startLine < endLine; ++startLine) {
        start = startLine * size.width * bpp;
        end = start + borderWidth * bpp;
        for (; start < end; start += bpp)
            [colorStrategy processPixel:(pixel_t*)&data[start]];
    }

    // right
    startLine = borderWidth;
    endLine = size.height - borderWidth * 2;
    for (; startLine < endLine; ++startLine) {
        start = (startLine * size.width + (size.width - borderWidth)) * bpp;
        end = start + borderWidth * bpp;
        for (; start < end; start += bpp)
            [colorStrategy processPixel:(pixel_t*)&data[start]];
    }
}

@end
