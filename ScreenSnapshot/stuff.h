//
//  sutff.h
//  ScreenSnapshot
//
//  Created by Sergio Kunats on 2/8/13.
//
//

#ifndef ScreenSnapshot_stuff_h
#define ScreenSnapshot_stuff_h

#import <QuartzCore/QuartzCore.h>

// slow
typedef struct pixel_ss {
    unsigned char r;
    unsigned char g;
    unsigned char b;
    unsigned char a;
} pixel_tt;

// fast
typedef struct pixel_s {
    unsigned char b;
    unsigned char g;
    unsigned char r;
    unsigned char a;
} pixel_t;

typedef struct hsv_color_s {
    unsigned short hue;
    unsigned char  sat;
    unsigned char  val;
} hsv_color_t;

extern void RGB2HSV(float r, float g, float b,
                    float *h, float *s, float *v);

extern void HSV2RGB(float h, float s, float v,
                    float *r, float *g, float *b);

extern void RGB2XY(float r, float g, float b,
                   CGPoint *xyPoint);

#endif
