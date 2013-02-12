//
//  ImageLoopStrategy.h
//  ScreenSnapshot
//
//  Created by Sergio Kunats on 2/8/13.
//
//

#import <Foundation/Foundation.h>
#import "ColorStrategy.h"

@protocol ImageLoopDelegate <NSObject>

- (void) loopCompleteWithColors:(hsv_color_t *)HSV RGB:(CGColorRef)RGBColor;

@end

@interface ImageLoopStrategy : NSObject {
    ColorStrategy *colorStrategy;
}

@property (nonatomic, strong) ColorStrategy* colorStrategy;
@property (nonatomic, copy) void (^onComplete)(hsv_color_t*, CGColorRef);
@property (nonatomic, unsafe_unretained) id<ImageLoopDelegate> delegate;

- (id) initWithColorStrategy:(ColorStrategy*)strategy;

- (void) loop:(void *)data size:(CGSize)size bpp:(unsigned short)bpp;
- (void) processImage:(CGImageRef)inImage;

- (void) done;

@end
