//
//  DominantColorStrategy.h
//  ScreenSnapshot
//
//  Created by Sergio Kunats on 2/8/13.
//
//

#import <Foundation/Foundation.h>
#import "ColorStrategy.h"

@interface DominantColorStrategy : ColorStrategy {
    unsigned long totalPixels;
    float totalSat; // hSv
    float totalVal; // hsV
    unsigned int* hues;
    unsigned short precision;
}

//@property (nonatomic, readonly) float dominantHue;

@end
