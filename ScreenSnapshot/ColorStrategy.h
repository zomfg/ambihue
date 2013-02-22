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

@property (nonatomic, readonly) hsv_color_t * HSVColor;
@property (nonatomic, readonly) CGColorRef RGBColor;
@property (nonatomic, readonly) CGPoint XYColor;

- (void) reset;
- (void) processPixel:(pixel_t*)pixel;

@end
