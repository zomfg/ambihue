//
//  AverageRGBColorStrategy.m
//  ScreenSnapshot
//
//  Created by Sergio Kunats on 2/8/13.
//
//

#import "AverageColorStrategy.h"
#import "stuff.h"

@implementation AverageColorStrategy

- (id) init {
    if ((self = [super init]))
        [self reset];
    return self;
}

- (void) reset {
    totalRED   = 0;
    totalGREEN = 0;
    totalBLUE  = 0;
    totalPixels= 0;
}

- (void) processPixel:(pixel_t*)pixel {
    totalRED   += pixel->r;
    totalGREEN += pixel->g;
    totalBLUE  += pixel->b;
    ++totalPixels;
}

- (void) calculateRGBColor:(CGColorRef *)color {
    if (totalPixels < 1)
        return;
    *color = CGColorCreateGenericRGB(totalRED / totalPixels / 255.0,
                                     totalGREEN / totalPixels / 255.0,
                                     totalBLUE / totalPixels / 255.0,
                                     1.0); // alpha
}

- (void) calculateHSVColor:(hsv_color_t*)color {
    if (totalPixels < 1)
        return;
    float h,s,v;
    RGB2HSV(totalRED / totalPixels / 255.0f,
            totalGREEN / totalPixels / 255.0f,
            totalBLUE / totalPixels / 255.0f,
            &h, &s, &v);
    color->hue = h * 0xffff;
    color->sat = s * 0xff;
    color->val = v * 0xff;
}

@end
