//
//  SBSlingshot.h
//  sb2slingshot
//
//  Created by Aaron Kaufer on 9/22/13.
//  Copyright (c) 2013 Aaron Kaufer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "definitions.h"


@class SBCharacter;



@interface SBSlingshot : SKNode

//the line vector represents the half of the line spawning from the midpoint
// point1 is located at position+lineVector
// point2 is located at position-lineVector
@property CGVector lineVector;

//these are the end point
@property (strong) SKShapeNode *point1, *point2;

//if there is a node attached, then the two lines attach to the node and their corresponding endpoints, but if there isn't then line1 attaches the two endpoints
//line1 originates at point1, line2 originates at point2
@property (strong) SKShapeNode *line1, *line2;

//this is the object that it is connected to, if it is nil then it just creates two straight lines
@property (strong) SBCharacter *attachedNode;

//the default constructor
-(id)initWithPosition:(CGPoint)pos andLineVector:(CGVector)lv;

-(BOOL)attachNode:(SBCharacter*)node;
-(void)detachNode;


@end

