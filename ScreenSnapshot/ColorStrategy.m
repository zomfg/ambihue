//
//  ColorStrategy.m
//  ScreenSnapshot
//
//  Created by Sergio Kunats on 2/8/13.
//
//

#import "ColorStrategy.h"

@implementation ColorStrategy

- (void) processPixel:(pixel_t*)pixel {

}

- (void) calculateRGBColor:(CGColorRef *)color {
//    *color = CGColorCreateGenericRGB(totalRED / totalPixels / 255.0,
//                                     totalGREEN / totalPixels / 255.0,
//                                     totalBLUE / totalPixels / 255.0,
//                                     1.0); // alpha
}

- (void) calculateHSVColor:(hsv_color_t*)color {
//    float h,s,v;
//    RGB2HSV(totalRED / totalPixels / 255.0f,
//            totalGREEN / totalPixels / 255.0f,
//            totalBLUE / totalPixels / 255.0f,
//            &h, &s, &v);
//    color->hue = h * 0xffff;
//    color->sat = s * 0xff;
//    color->val = v * 0xff;
}

@end
