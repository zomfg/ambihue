//
//  DominantColorStrategy.m
//  ScreenSnapshot
//
//  Created by Sergio Kunats on 2/8/13.
//
//

#import "DominantColorStrategy.h"

@implementation DominantColorStrategy

- (id) init {
    if ((self = [super init])) {
        precision = 20;
        totalPixels = 0;
        totalVal = 0.0f;
        totalSat = 0.0f;
        hues = calloc(precision, sizeof(unsigned int));
    }
    return self;
}

- (void) processPixel:(pixel_t *)pixel {
    float h,s,v;
    RGB2HSV(pixel->r / 255.0f,
            pixel->g / 255.0f,
            pixel->b / 255.0f,
            &h, &s, &v);
    unsigned short hueIndex = h * (precision - 1);
    ++hues[hueIndex];
    totalSat += s;
    totalVal += v;
    ++totalPixels;
}

- (float) dominantHue {
    unsigned short max = 0;
    unsigned int count = 0;
    for (unsigned short i = 0; i < precision; ++i)
        if (count < hues[i]) {
            max = i;
            count = hues[i];
        }
    return ((float)max / (float)precision);
}

- (void) calculateRGBColor:(CGColorRef *)color {
    float r,g,b;
    HSV2RGB([self dominantHue],                   // H
            totalSat / totalPixels,   // S
            totalVal / totalPixels,   // V
            &r, &g, &b);                        // RGB
    *color = CGColorCreateGenericRGB(r, g, b, 1.0); // alpha
}

- (void) calculateHSVColor:(hsv_color_t*)color {
//    for (int i = 0; i < self.precision; i++) {
//        NSLog(@"Hue[%d] | %f = %d", i, (float)i / (float)self.precision * 360.0f, self.hues[i]);
//    }
//    NSLog(@"DOMINANT HUE %f", self.dominantHue);
    color->hue = self.dominantHue * 0xffff;
    color->sat = totalSat / totalPixels * 0xff;
    color->val = totalVal / totalPixels * 0xff;
}

@end
