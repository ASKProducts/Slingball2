//
//  Definitions.h
//  Slingball2
//
//  Created by Aaron Kaufer on 9/24/13.
//  Copyright (c) 2013 Aaron Kaufer. All rights reserved.
//


#import <Foundation/Foundation.h>

#define SLINGSHOT_ENDPOINT_SIZE 10
#define SLINGSHOT_ENDPOINT_LINE_COLOR [UIColor blackColor]
#define SLINGSHOT_ENDPOINT_FILL_COLOR [UIColor grayColor]
#define SLINGSHOT_ENDPOINT_LINEWIDTH 1
#define SLINGSHOT_LINE_COLOR [UIColor redColor]
#define SLINGSHOT_LINE_WIDTH 2
#define SLINGSHOT_PULL_TO_LINE_RATIO 1.5
#define SLINGSHOT_FOLLOW_UPDATES_INTERVAL 1.0/20.0
#define SLINGSHOT_ENDPOINT_CATEGORY_BIT_MASK (1 << 0)

#define CHARACTER_VELOCITY_TO_PULL_RATIO 2
#define CHARACTER_RESTITUTION 1.0
#define CHARACTER_LINEAR_DAMPING 0.1
#define CHARACTER_START_POSITION CGPointMake(self.size.width/2,(2.0/5.0)*self.size.height);
#define CHARACTER_RELATIVE_MAX_HEIGHT (3.0/5.0)*self.size.height
#define CHARACTER_RADIUS 10

#define WALL_RESTITUTION 1.0

CGVector CGVectorFromDistance(CGPoint p1, CGPoint p2);
CGVector CGVectorSum(CGVector v1, CGVector v2);
CGVector CGVectorProduct(CGVector v1, CGVector v2);
CGVector CGVectorScale(CGVector v, CGFloat scale);
CGVector CGVectorNegate(CGVector v);

CGPoint CGPointFromVector(CGVector v);
CGPoint CGPointPlusVector(CGPoint p, CGVector v);

CGFloat CGVectorMagnitude(CGVector v);
CGFloat CGPointDistance(CGPoint p1, CGPoint p2);

CGRect CGRectFromCircle(CGPoint c, CGFloat r);
