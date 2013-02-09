//
//  FullImageLoopStrategy.m
//  ScreenSnapshot
//
//  Created by Sergio Kunats on 2/8/13.
//
//

#import "FullImageLoopStrategy.h"

@implementation FullImageLoopStrategy

- (void) loop:(void *)data size:(CGSize)size bpp:(unsigned short)bpp
{
    void *end = &data[(size_t)size.width * (size_t)size.height * bpp];

    for (void *start = data; start != end; start += 4)
        [colorStrategy processPixel:(pixel_t*)data];
}

@end
