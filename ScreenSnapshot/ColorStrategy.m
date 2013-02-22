//
//  ColorStrategy.m
//  ScreenSnapshot
//
//  Created by Sergio Kunats on 2/8/13.
//
//

#import "ColorStrategy.h"

@implementation ColorStrategy

@synthesize HSVColor, RGBColor, XYColor;

- (void) reset {
    
}

- (void) processPixel:(pixel_t*)pixel {

}

- (CGColorRef) RGBColor {
    return NULL;
}

- (hsv_color_t *) HSVColor {
    return NULL;
}

- (CGPoint) XYColor {
    return CGPointZero;
}

@end
