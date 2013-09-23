//
//  definitions.h
//  sb2slingshot
//
//  Created by Aaron Kaufer on 9/22/13.
//  Copyright (c) 2013 Aaron Kaufer. All rights reserved.
//

#ifndef sb2slingshot_definitions_h
#define sb2slingshot_definitions_h

#define SLINGSHOT_ENDPOINT_SIZE 10
#define SLINGSHOT_ENDPOINT_LINE_COLOR [UIColor blackColor]
#define SLINGSHOT_ENDPOINT_FILL_COLOR [UIColor grayColor]
#define SLINGSHOT_ENDPOINT_LINEWIDTH 1
#define SLINGSHOT_LINE_COLOR [UIColor redColor]
#define SLINGSHOT_LINE_WIDTH 2
#define SLINGSHOT_PULL_TO_LINE_RATIO 1.5

#define CHARACTER_VELOCITY_TO_PULL_RATIO 1.7
#define CHARACTER_RESTITUTION 1.0
#define CHARACTER_LINEAR_DAMPING 0.1

#define WALL_RESTITUTION 1.0

#define CGVectorMagnitude(v) (sqrtf(v.dx*v.dx+v.dy*v.dy))
#define distanceBetween(p1, p2) (sqrtf((p1.x-p2.x)*(p1.x-p2.x) + (p1.y-p2.y)*(p1.y-p2.y)))


#endif
