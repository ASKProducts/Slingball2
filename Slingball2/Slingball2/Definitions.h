//
//  Definitions.h
//  Slingball2
//
//  Created by Aaron Kaufer on 9/24/13.
//  Copyright (c) 2013 Aaron Kaufer. All rights reserved.
//


#import <Foundation/Foundation.h>

#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define DEVICE_SPECIFIC(iphone,ipad) ((IS_IPHONE)?(iphone):(ipad))

#define SLINGSHOT_ENDPOINT_SIZE DEVICE_SPECIFIC(10,30)
#define SLINGSHOT_ENDPOINT_LINE_COLOR [UIColor blackColor]
#define SLINGSHOT_ENDPOINT_FILL_COLOR [UIColor grayColor]
#define SLINGSHOT_ENDPOINT_LINEWIDTH 1
#define SLINGSHOT_LINE_COLOR [UIColor redColor]
#define SLINGSHOT_LINE_WIDTH DEVICE_SPECIFIC(2,5)
#define SLINGSHOT_PULL_TO_LINE_RATIO 1.5
#define SLINGSHOT_FOLLOW_UPDATES_INTERVAL 1.0/20.0
#define SLINGSHOT_ENDPOINT_CATEGORY_BIT_MASK (1 << 0)
#define SLINGSHOT_LINE_RADIUS DEVICE_SPECIFIC(35,100)
#define SLINGSHOT_SPACING DEVICE_SPECIFIC(100,200)
#define SLINGSHOT_ANGLE_DEVIATION 50

#define CHARACTER_VELOCITY_TO_PULL_RATIO DEVICE_SPECIFIC(2.3,1)
#define CHARACTER_RESTITUTION 1.0
#define CHARACTER_LINEAR_DAMPING 0.1
#define CHARACTER_START_POSITION CGPointMake(self.size.width/2, 1.0/5.0*self.size.height)
#define CHARACTER_RELATIVE_MAX_HEIGHT (3.0/5.0)*self.size.height
#define CHARACTER_RADIUS DEVICE_SPECIFIC(10,30)
#define CHARACTER_MASS DEVICE_SPECIFIC(10,35)

#define SCENE_GRAVITY CGVectorMake(0,DEVICE_SPECIFIC(-7,-10))
#define WALL_RESTITUTION 1.0

#define ABS_(A) ((A)<0?-(A):(A))
#define RANDOM(a,b) ((int)a)+(arc4random()%((int)ABS_(b-a)))

CGVector CGVectorFromDistance(CGPoint p1, CGPoint p2);
CGVector CGVectorSum(CGVector v1, CGVector v2);
CGVector CGVectorProduct(CGVector v1, CGVector v2);
CGVector CGVectorScale(CGVector v, CGFloat scale);
CGVector CGVectorNegate(CGVector v);
CGVector CGVectorMakeUnit(CGFloat direction);
CGVector CGVectorMakeMag(CGFloat magnitude, CGFloat direction);

CGPoint CGPointFromVector(CGVector v);
CGPoint CGPointPlusVector(CGPoint p, CGVector v);

CGFloat CGVectorMagnitude(CGVector v);
CGFloat CGPointDistance(CGPoint p1, CGPoint p2);

CGRect CGRectFromCircle(CGPoint c, CGFloat r);
