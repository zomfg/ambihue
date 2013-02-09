//
//  FullImageLoopStrategy.m
//  ScreenSnapshot
//
//  Created by Sergio Kunats on 2/8/13.
//
//

#import "FullImageLoopStrategy.h"

//const int max_threads = 1;
//int threads = max_threads;
//dispatch_queue_t loop_queue = NULL;

@implementation FullImageLoopStrategy

//- (void) done {
////    NSLog(@"THREADS %d", threads);
//    if (--threads < 1)
//        return [super done];
//}

- (void) loop:(void *)data size:(CGSize)size bpp:(unsigned short)bpp
{
//    if (loop_queue == NULL)
//        loop_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
//        loop_queue = dispatch_queue_create("com.hue.imageloop.full", NULL);
//    threads = max_threads;
//    __block size_t coef = (size_t)size.width * (size_t)size.height / max_threads * pixelSize;
//    for (__block int t = 0; t < max_threads; ++t) {
//        dispatch_async(loop_queue, ^{
//            void *start = &data[coef * t];
//            void *end = &data[coef * (t + 1)];
//            for (; start != end; start += step)
//                [colorStrategy processPixel:(pixel_t*)start];
//            dispatch_async(dispatch_get_main_queue(), ^{
                //                NSLog(@"COEF %ld, STEP %d, T %d, FROM %ld TO %ld = %ld", coef, step, t, start, end, end -start);
//                [self done];
//            });
//        [self done];
//            [self performSelectorOnMainThread:@selector(done) withObject:nil waitUntilDone:NO];
//        });
//    }
//   [self done];
    unsigned short pixelSize = sizeof(unsigned char) * bpp;
    void *end = &data[(size_t)size.width * (size_t)size.height * pixelSize];
    for (void *start = data; start < end; start += pixelSize)
        [colorStrategy processPixel:(pixel_t*)start];
    [self done];
}

@end
