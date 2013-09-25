//
//  SBSlingshot.m
//  sb2slingshot
//
//  Created by Aaron Kaufer on 9/22/13.
//  Copyright (c) 2013 Aaron Kaufer. All rights reserved.
//

#import "SBSlingshot.h"
#import "SBCharacter.h"
#import "Definitions.h"

@implementation SBSlingshot

-(id)initWithPosition:(CGPoint)pos andLineVector:(CGVector)lv{
    self = [super init];
    if(self){
        self.lineVector = lv;
        
        self.point1 = [[SKShapeNode alloc] init];
        CGMutablePathRef p1Path = CGPathCreateMutable();
        CGPoint p1point = CGPointFromVector(self.lineVector);
        CGPathAddEllipseInRect(p1Path, NULL, CGRectFromCircle(p1point, SLINGSHOT_ENDPOINT_SIZE/2));
        self.point1.path = p1Path;
        self.point1.strokeColor = SLINGSHOT_ENDPOINT_LINE_COLOR;
        self.point1.fillColor = SLINGSHOT_ENDPOINT_FILL_COLOR;
        self.point1.lineWidth = SLINGSHOT_ENDPOINT_LINEWIDTH;
        
        self.point2 = [[SKShapeNode alloc] init];
        CGMutablePathRef p2Path = CGPathCreateMutable();
        CGPoint p2point = CGPointFromVector(CGVectorScale(self.lineVector, -1));
        CGPathAddEllipseInRect(p2Path, NULL, CGRectFromCircle(p2point, SLINGSHOT_ENDPOINT_SIZE/2));
        self.point2.path = p2Path;
        self.point2.strokeColor = SLINGSHOT_ENDPOINT_LINE_COLOR;
        self.point2.fillColor = SLINGSHOT_ENDPOINT_FILL_COLOR;
        self.point2.lineWidth = SLINGSHOT_ENDPOINT_LINEWIDTH;
        
        self.line1 = [[SKShapeNode alloc] init];
        CGMutablePathRef l1Path = CGPathCreateMutable();
        CGPathMoveToPoint(l1Path, NULL, p1point.x, p1point.y);
        CGPathAddLineToPoint(l1Path, NULL, p2point.x,p2point.y);
        self.line1.path = l1Path;
        self.line1.strokeColor = SLINGSHOT_LINE_COLOR;
        self.line1.lineWidth = SLINGSHOT_LINE_WIDTH;
        
        self.line2 = [[SKShapeNode alloc] init];
        CGMutablePathRef l2Path = CGPathCreateMutable();
        CGPathMoveToPoint(l2Path, NULL, p2point.x, p2point.y);
        self.line2.path = l2Path;
        self.line2.strokeColor = SLINGSHOT_LINE_COLOR;
        self.line2.lineWidth = SLINGSHOT_LINE_WIDTH;
        
        [self addChild:self.line1];
        [self addChild:self.line2];
        [self addChild:self.point1];
        [self addChild:self.point2];
        
        self.position = pos;
    }
    return self;
}

-(BOOL)attachNode:(SBCharacter*)node{
    if(self.attachedNode)
        return NO;
    
    self.attachedNode = node;
    [self.attachedNode attachToSlingshot:self];
    self.line1.zPosition = self.attachedNode.zPosition-1;
    self.line2.zPosition = self.attachedNode.zPosition-1;
    
    
    
    [self runAction:[SKAction repeatActionForever:[SKAction customActionWithDuration:SLINGSHOT_FOLLOW_UPDATES_INTERVAL actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        
        CGPoint p1point = CGPointFromVector(self.lineVector);
        CGPoint p2point = CGPointFromVector(CGVectorScale(self.lineVector, -1));
        CGPoint nodePoint = [self.parent convertPoint:self.attachedNode.position toNode:self];
        
        CGMutablePathRef l1Path = CGPathCreateMutable();
        CGPathMoveToPoint(l1Path, NULL, p1point.x, p1point.y);
        CGPathAddLineToPoint(l1Path, NULL, nodePoint.x,nodePoint.y);
        
        CGMutablePathRef l2Path = CGPathCreateMutable();
        CGPathMoveToPoint(l2Path, NULL, p2point.x, p2point.y);
        CGPathAddLineToPoint(l2Path, NULL, nodePoint.x,nodePoint.y);
        
        self.line1.path = l1Path;
        self.line2.path = l2Path;
        
        
    }]] withKey:@"track"];
    

    return YES;
}
-(void)detachNode{
    self.attachedNode = nil;
    [self removeActionForKey:@"track"];
    
    CGPoint p1point = CGPointMake(self.lineVector.dx, self.lineVector.dy);
    CGPoint p2point = CGPointMake(-self.lineVector.dx, -self.lineVector.dy);
    
    CGMutablePathRef l1Path = CGPathCreateMutable();
    CGPathMoveToPoint(l1Path, NULL, p1point.x, p1point.y);
    CGPathAddLineToPoint(l1Path, NULL, p2point.x,p2point.y);
    
    CGMutablePathRef l2Path = CGPathCreateMutable();
    CGPathMoveToPoint(l2Path, NULL, p2point.x, p2point.y);

    self.line1.path = l1Path;
    self.line2.path = l2Path;
}



@end
