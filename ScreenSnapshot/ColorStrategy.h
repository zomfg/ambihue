//
//  ColorStrategy.h
//  ScreenSnapshot
//
//  Created by Sergio Kunats on 2/8/13.
//
//

#import <Foundation/Foundation.h>
#include "stuff.h"

@interface ColorStrategy : NSObject

- (void) processPixel:(pixel_t*)pixel;
- (void) calculateHSVColor:(hsv_color_t*)color;
- (void) calculateRGBColor:(CGColorRef *)color;

@end
