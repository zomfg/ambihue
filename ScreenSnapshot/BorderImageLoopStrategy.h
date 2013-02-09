//
//  BorderImageLoopStrategy.h
//  ScreenSnapshot
//
//  Created by Sergio Kunats on 2/8/13.
//
//

#import <Foundation/Foundation.h>
#import "ImageLoopStrategy.h"

@interface BorderImageLoopStrategy : ImageLoopStrategy {
    unsigned int borderWidth;
}

@property (nonatomic, assign) unsigned int borderWidth;

@end
