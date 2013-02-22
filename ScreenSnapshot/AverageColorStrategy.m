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

- (CGColorRef) RGBColor {
    if (totalPixels < 1)
        return NULL;
    return CGColorCreateGenericRGB(totalRED / totalPixels / 255.0,
                                     totalGREEN / totalPixels / 255.0,
                                     totalBLUE / totalPixels / 255.0,
                                     1.0); // alpha
}

- (hsv_color_t *) HSVColor {
    if (totalPixels < 1)
        return NULL;
    hsv_color_t *color = malloc(sizeof(hsv_color_t));
    float h,s,v;
    RGB2HSV(totalRED / totalPixels / 255.0f,
            totalGREEN / totalPixels / 255.0f,
            totalBLUE / totalPixels / 255.0f,
            &h, &s, &v);
    color->hue = h * 0xfffe;
    color->sat = s * 0xfe;
    color->val = v * 0xfe;
    return color;
}

- (CGPoint) XYColor {
    CGPoint p = CGPointZero;
    RGB2XY(totalRED / totalPixels / 255.0f,
           totalGREEN / totalPixels / 255.0f,
           totalBLUE / totalPixels / 255.0f,
           &p);
    return p;
}

@end
