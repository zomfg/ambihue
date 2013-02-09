//
//  AverageRGBColorStrategy.h
//  ScreenSnapshot
//
//  Created by Sergio Kunats on 2/8/13.
//
//

#import <Foundation/Foundation.h>
#include "stuff.h"
#import "ColorStrategy.h"

@interface AverageColorStrategy : ColorStrategy {
    unsigned long totalRED;
    unsigned long totalGREEN;
    unsigned long totalBLUE;
    unsigned long totalPixels;
}

@end
