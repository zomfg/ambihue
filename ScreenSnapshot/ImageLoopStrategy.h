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

@property (nonatomic, strong) ColorStrategy* colorStrategy;
@property (nonatomic, strong) void (^onComplete)(hsv_color_t*, CGColorRef);

- (id) initWithColorStrategy:(ColorStrategy*)strategy;

- (void) loop:(void *)data size:(CGSize)size bpp:(unsigned short)bpp;
- (void) processImage:(CGImageRef)inImage;

- (void) done;

@end
