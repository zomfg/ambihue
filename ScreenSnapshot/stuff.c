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


// Original source (C#)
// https://github.com/Q42/Q42.HueApi/blob/master/src/Q42.HueApi/HueColorConverter.cs

const CGPoint Red = {0.675f, 0.322f};
const CGPoint Lime = {0.4091f, 0.518f};
const CGPoint Blue = {0.167f, 0.04f};
const float factor = 10000.0f;
const int maxX = 452;
const int maxY = 302;
double CrossProduct(CGPoint p1, CGPoint p2);
bool CheckPointInLampsReach(CGPoint p);
CGPoint GetClosestPointToPoint(CGPoint A, CGPoint B, CGPoint P);
double GetDistanceBetweenTwoPoints(CGPoint one, CGPoint two);

/// <summary>
/// Calculates crossProduct of two 2D vectors / points.
/// </summary>
/// <param name="p1"> p1 first point used as vector</param>
/// <param name="p2">p2 second point used as vector</param>
/// <returns>crossProduct of vectors</returns>
double CrossProduct(CGPoint p1, CGPoint p2)
{
    return (p1.x * p2.y - p1.y * p2.x);
}

bool CheckPointInLampsReach(CGPoint p)
{
    CGPoint v1 = CGPointMake(Lime.x - Red.x, Lime.y - Red.y);
    CGPoint v2 = CGPointMake(Blue.x - Red.x, Blue.y - Red.y);

    CGPoint q = CGPointMake(p.x - Red.x, p.y - Red.y);

    double s = CrossProduct(q, v2) / CrossProduct(v1, v2);
    double t = CrossProduct(v1, q) / CrossProduct(v1, v2);

    if ((s >= 0.0f) && (t >= 0.0f) && (s + t <= 1.0f))
    {
        return true;
    }
    else
    {
        return false;
    }
}

/// <summary>
/// Find the closest point on a line.
/// This point will be within reach of the lamp.
/// </summary>
/// <param name="A">A the point where the line starts</param>
/// <param name="B">B the point where the line ends</param>
/// <param name="P">P the point which is close to a line.</param>
/// <returns> the point which is on the line.</returns>
CGPoint GetClosestPointToPoint(CGPoint A, CGPoint B, CGPoint P)
{
    CGPoint AP = CGPointMake(P.x - A.x, P.y - A.y);
    CGPoint AB = CGPointMake(B.x - A.x, B.y - A.y);
    double ab2 = AB.x * AB.x + AB.y * AB.y;
    double ap_ab = AP.x * AB.x + AP.y * AB.y;

    double t = ap_ab / ab2;

    if (t < 0.0f)
        t = 0.0f;
    else if (t > 1.0f)
        t = 1.0f;

    return CGPointMake(A.x + AB.x * t, A.y + AB.y * t);
}

/// <summary>
/// Find the distance between two points.
/// </summary>
/// <param name="one"></param>
/// <param name="two"></param>
/// <returns>the distance between point one and two</returns>
double GetDistanceBetweenTwoPoints(CGPoint one, CGPoint two)
{
    double dx = one.x - two.x; // horizontal difference
    double dy = one.y - two.y; // vertical difference
    double dist = sqrt(dx * dx + dy * dy);

    return dist;
}


void RGB2XY(float red, float green, float blue,
            CGPoint *xyPoint)
{
    double r = (red > 0.04045f) ? powf((red + 0.055f) / (1.0f + 0.055f), 2.4f) : (red / 12.92f);
    double g = (green > 0.04045f) ? powf((green + 0.055f) / (1.0f + 0.055f), 2.4f) : (green / 12.92f);
    double b = (blue > 0.04045f) ? powf((blue + 0.055f) / (1.0f + 0.055f), 2.4f) : (blue / 12.92f);

    double X = r * 0.4360747f + g * 0.3850649f + b * 0.0930804f;
    double Y = r * 0.2225045f + g * 0.7168786f + b * 0.0406169f;
    double Z = r * 0.0139322f + g * 0.0971045f + b * 0.7141733f;

    (*xyPoint).x = X / (X + Y + Z + 0.0000001f);
    (*xyPoint).y = Y / (X + Y + Z + 0.0000001f);

    //    if (Double.IsNaN(cx))
    //    {
    //        cx = 0.0f;
    //    }
    //
    //    if (Double.IsNaN(cy))
    //    {
    //        cy = 0.0f;
    //    }

    //Check if the given XY value is within the colourreach of our lamps.
    bool inReachOfLamps = CheckPointInLampsReach(*xyPoint);

    if (!inReachOfLamps)
    {
        //It seems the colour is out of reach
        //let's find the closes colour we can produce with our lamp and send this XY value out.

        //Find the closest point on each line in the triangle.
        CGPoint pAB = GetClosestPointToPoint(Red, Lime, *xyPoint);
        CGPoint pAC = GetClosestPointToPoint(Blue, Red, *xyPoint);
        CGPoint pBC = GetClosestPointToPoint(Lime, Blue, *xyPoint);

        //Get the distances per point and see which point is closer to our Point.
        double dAB = GetDistanceBetweenTwoPoints(*xyPoint, pAB);
        double dAC = GetDistanceBetweenTwoPoints(*xyPoint, pAC);
        double dBC = GetDistanceBetweenTwoPoints(*xyPoint, pBC);

        double lowest = dAB;
        CGPoint closestPoint = pAB;

        if (dAC < lowest)
        {
            lowest = dAC;
            closestPoint = pAC;
        }
        if (dBC < lowest)
        {
            lowest = dBC;
            closestPoint = pBC;
        }

        //Change the xy value to a value which is within the reach of the lamp.
        (*xyPoint).x = closestPoint.x;
        (*xyPoint).y = closestPoint.y;
    };
}