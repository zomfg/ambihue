//
//  ImageLoopStrategy.h
//  ScreenSnapshot
//
//  Created by Sergio Kunats on 2/8/13.
//
//

#import <Foundation/Foundation.h>
#import "ColorStrategy.h"

@interface ImageLoopStrategy : NSObject {
    ColorStrategy *colorStrategy;
}

@property (nonatomic, retain) ColorStrategy* colorStrategy;

- (id) initWithColorStrategy:(ColorStrategy*)strategy;

- (void) processImage:(CGImageRef)inImage HSVColor:(hsv_color_t*)hsv_color;

@end
