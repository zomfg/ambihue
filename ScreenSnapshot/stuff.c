//
//  stuff.c
//  ScreenSnapshot
//
//  Created by Sergio Kunats on 2/8/13.
//
//

#include <stdio.h>
#include <math.h>
#define MIN(x, y) (((x) < (y)) ? (x) : (y))
#include "stuff.h"

void RGB2HSV(float r, float g, float b,
                    float *h, float *s, float *v)
{
    float K = 0.f;

    if (g < b)
    {
        float tmp = g; g = b; b = tmp;
        K = -1.f;
    }

    if (r < g)
    {
        float tmp = r; r = g; g = tmp;
        K = -0.33333333333f - K;
    }

    float chroma = r - MIN(g, b);
    *h = fabs(K + (g - b) / (6.f * chroma + 1e-20f));
    *s = chroma / (r + 1e-20f);
    *v = r;
}

void HSV2RGB(float h, float s, float v,
             float *r, float *g, float *b)
{
    unsigned char i = h * 6;
    float f = h * 6 - i;
    float p = v * (1 - s);
    float q = v * (1 - f * s);
    float t = v * (1 - (1 - f) * s);

    switch (i){
        case 0: *r = v, *g = t, *b = p; break;
        case 1: *r = q, *g = v, *b = p; break;
        case 2: *r = p, *g = v, *b = t; break;
        case 3: *r = p, *g = q, *b = v; break;
        case 4: *r = t, *g = p, *b = v; break;
        case 5: *r = v, *g = p, *b = q; break;
    };
}