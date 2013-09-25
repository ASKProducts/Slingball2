//
//  Definitions.m
//  Slingball2
//
//  Created by Aaron Kaufer on 9/24/13.
//  Copyright (c) 2013 Aaron Kaufer. All rights reserved.
//

#import "Definitions.h"

#pragma mark - CGVector

CGVector CGVectorFromDistance(CGPoint p1, CGPoint p2){
    return CGVectorMake(p2.x - p1.x , p2.y - p1.y);
}

CGVector CGVectorSum(CGVector v1, CGVector v2){
    return CGVectorMake(v1.dx + v2.dx, v1.dy + v2.dy);
}

CGVector CGVectorProduct(CGVector v1, CGVector v2){
    return CGVectorMake(v1.dx * v2.dx, v1.dy * v2.dy);
}

CGVector CGVectorScale(CGVector v, CGFloat scale){
    return CGVectorMake(v.dx * scale, v.dy * scale);
}

#pragma mark - CGPoint

CGPoint CGPointFromVector(CGVector v){
    return CGPointMake(v.dx, v.dy);
}

CGPoint CGPointPlusVector(CGPoint p, CGVector v){
    return CGPointMake(p.x + v.dx, p.y + v.dy);
}

#pragma mark - CGFloat

CGFloat CGVectorMagnitude(CGVector v){
    return sqrtf( v.dx*v.dx + v.dy*v.dy );
}

CGFloat CGPointDistance(CGPoint p1, CGPoint p2){
    return CGVectorMagnitude(CGVectorFromDistance(p1, p2));
    //return sqrtf((p1.x-p2.x)*(p1.x-p2.x) + (p1.y-p2.y)*(p1.y-p2.y));
}

#pragma mark - CGRect

CGRect CGRectFromCircle(CGPoint c, CGFloat r){
    return CGRectMake(c.x-r, c.y-r, r*2, r*2);
}