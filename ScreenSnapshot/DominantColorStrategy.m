//
//  DominantColorStrategy.m
//  ScreenSnapshot
//
//  Created by Sergio Kunats on 2/8/13.
//
//

#import "DominantColorStrategy.h"

typedef struct fhsv_s {
    float h;
    float s;
    float v;
} fhsv_t;

#define COLOR_SIZE 256
#define COLOR_MAX  255

fhsv_t hue_lookup_table[COLOR_SIZE][COLOR_SIZE][COLOR_SIZE];

@implementation DominantColorStrategy

@synthesize dominantHue, precision;

- (void) precalculateHues {
//    if (hue_lookup_table)
//        return;
//    hue_lookup_table = malloc(COLOR_SIZE * sizeof(fhsv_t**));
    fhsv_t *hsv;
    unsigned short r,g,b;
    float fr,fg,fb;
    for (r = 0; r <= COLOR_MAX; r++) {
//        hue_lookup_table[r] = malloc(COLOR_SIZE * sizeof(fhsv_t*));
        fr = (float)r / (float)COLOR_MAX;
        for (g = 0; g <= COLOR_MAX; g++) {
//            hue_lookup_table[r][g] = malloc(COLOR_SIZE * sizeof(fhsv_t));
            fg = (float)g / (float)COLOR_MAX;
            for (b = 0; b <= COLOR_MAX; b++) {
                fb = (float)b / (float)COLOR_MAX;
                hsv = &hue_lookup_table[r][g][b];
                RGB2HSV(fr, fg, fb, &(hsv->h), &(hsv->s), &(hsv->v));
            }
        }
    }
}

- (id) init {
    if ((self = [super init])) {
        precision = 40;
        hues = malloc(precision * sizeof(*hues));
        [self reset];
        [self precalculateHues];
    }
    return self;
}

- (void) setPrecision:(unsigned short)newPrecision {
    if (newPrecision == precision || newPrecision == 0)
        return;
    precision = newPrecision;
    hues = realloc(hues, precision * sizeof(*hues));
    memset(hues, 0, precision * sizeof(*hues));
}

- (void) reset {
    totalPixels = 0;
    totalSat = 0.0f;
    totalVal = 0.0f;
    memset(hues, 0, precision * sizeof(*hues));
}

- (void) processPixel:(pixel_t *)pixel {
//    float h,s = 0.0f,v = 0.0f;
//    RGB2HSV(pixel->r / 255.0f,
//            pixel->g / 255.0f,
//            pixel->b / 255.0f,
//            &h, &s, &v);
//    unsigned short hueIndex = h * (precision - 1);
//    totalSat += s;
//    totalVal += v;

    fhsv_t *hsv = &hue_lookup_table[pixel->r][pixel->g][pixel->b];
    unsigned short hueIndex = hsv->h * (precision - 1);
    totalSat += hsv->s;
    totalVal += hsv->v;

    ++hues[hueIndex];
    ++totalPixels;
}

- (float) dominantHue {
    unsigned short dominantIndex = 0;
    unsigned long  dominantCount = 0;
    for (unsigned short i = 0; i < precision; ++i)
        if (dominantCount < hues[i]) {
            dominantIndex = i;
            dominantCount = hues[i];
        }
    return ((float)dominantIndex / (float)precision);
}

- (CGColorRef) RGBColor {
    if (totalPixels < 1)
        return NULL;
    float r,g,b;
    HSV2RGB([self dominantHue],                   // H
            totalSat / totalPixels,   // S
            totalVal / totalPixels,   // V
            &r, &g, &b);                        // RGB
    return CGColorCreateGenericRGB(r, g, b, 1.0); // alpha
}

- (hsv_color_t *) HSVColor {
    if (totalPixels < 1)
        return NULL;
    hsv_color_t *color = malloc(sizeof(hsv_color_t));
//    for (int i = 0; i < precision; i++) {
//        NSLog(@"Hue[%d] | %f = %d", i, (float)i / (float)precision * 360.0f, hues[i]);
//    }
//    NSLog(@"DOMINANT HUE %f", self.dominantHue);
    color->hue = self.dominantHue * 0xfffe;
    color->sat = totalSat / totalPixels * 0xfe;
    color->val = totalVal / totalPixels * 0xfe;
    return color;
}

- (void) dealloc {
    if (hues)
        free(hues);
}

@end
