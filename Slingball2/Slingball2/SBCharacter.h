//
//  SBCharacter.h
//  sb2slingshot
//
//  Created by Aaron Kaufer on 9/22/13.
//  Copyright (c) 2013 Aaron Kaufer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
//#include "definitions.h"

@class SBSlingshot;

@interface SBCharacter : SKSpriteNode

// this guy will be the circle the the ball actually is
@property SKShapeNode *icon;

// the slingshot that the ball is attached to, if it is nil then it is not attached to a slingshot
@property SBSlingshot *attachedSlingshot;


- (id)initWithCircleOfRadius:(CGFloat)radius andLineWidth:(CGFloat)lineWidth andFillColor:(UIColor*)fillColor andStrokeColor:(UIColor*)strokeColor;

-(void)attachToSlingshot:(SBSlingshot*)slingshot;
-(void)launch;

@end
