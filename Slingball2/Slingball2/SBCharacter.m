//
//  SBCharacter.m
//  sb2slingshot
//
//  Created by Aaron Kaufer on 9/22/13.
//  Copyright (c) 2013 Aaron Kaufer. All rights reserved.
//

#import "SBCharacter.h"
#import "SBSlingshot.h"
#import "Definitions.h"

@implementation SBCharacter
//@synthesize position = _position;

- (id)initWithCircleOfRadius:(CGFloat)radius andLineWidth:(CGFloat)lineWidth andFillColor:(UIColor*)fillColor andStrokeColor:(UIColor*)strokeColor{
    self = [super init];
    if (self) {
        self.icon = [[SKShapeNode alloc] init];
        CGPathRef p = CGPathCreateWithEllipseInRect(CGRectMake(-radius,-radius, radius*2, radius*2), NULL);
        self.icon.path = p;
        self.icon.lineWidth = lineWidth;
        self.icon.fillColor = fillColor;
        self.icon.strokeColor = strokeColor;
        [self addChild:self.icon];
        
        self.physicsBody.restitution = CHARACTER_RESTITUTION;
        self.physicsBody.linearDamping = CHARACTER_LINEAR_DAMPING;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
        
        self.radius = radius;
    }
    return self;
}

-(void)attachToSlingshot:(SBSlingshot *)slingshot{
    if(self.attachedSlingshot)
        return;
    
    //CGFloat s = fabs(CGVectorMagnitude(self.physicsBody.velocity));
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:0.1],
                                         [SKAction customActionWithDuration:0 actionBlock:^(SKNode *n, CGFloat f){
        self.physicsBody.velocity = CGVectorMake(0, 0);
        self.physicsBody.affectedByGravity = NO;
        self.position = slingshot.position;
        self.attachedSlingshot = slingshot;
    }],[SKAction moveTo:slingshot.position duration:0.2]]] withKey:@"moving in"];
    
    
}

-(void)launch{
    if(!self.attachedSlingshot)
        return;
    
    CGFloat gravity = [(SKScene*)self.parent physicsWorld].gravity.dy;
    SBSlingshot *slingshot = self.attachedSlingshot;

    CGVector dist = CGVectorFromDistance(slingshot.position, self.position);
    
    [self.physicsBody setVelocity:CGVectorScale(dist, gravity*CHARACTER_VELOCITY_TO_PULL_RATIO)];
    
    CGFloat timeToCenter = fabs(dist.dx / self.physicsBody.velocity.dx);
    
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:timeToCenter],
                                         [SKAction runBlock:^{
        [self.attachedSlingshot detachNode];
        self.attachedSlingshot = nil;
        self.physicsBody.affectedByGravity = YES;
    }]]]];
    
}

-(void)setPosition:(CGPoint)pos{
    
    if([self actionForKey:@"moving in"])return;
    
    if(!self.attachedSlingshot){
        [super setPosition:pos];
        return;
    }
    
    CGFloat vectorSize = CGVectorMagnitude(self.attachedSlingshot.lineVector)*SLINGSHOT_PULL_TO_LINE_RATIO;
    
    if(CGPointDistance(pos, self.attachedSlingshot.position) > vectorSize){
        
        CGVector dist = CGVectorFromDistance(self.attachedSlingshot.position, pos);
        CGVector delta = CGVectorScale(dist, vectorSize/CGVectorMagnitude(dist));
        
        [super setPosition:CGPointPlusVector(self.attachedSlingshot.position, delta)];
        
        return;
    }
    
    [super setPosition:pos];
}

-(BOOL)collidesWithSlingshot:(SBSlingshot*)slingshot{
    
    CGVector lineVector = slingshot.lineVector;
    if(lineVector.dx == 0) lineVector.dx = 0.01;
    if(lineVector.dy == 0) lineVector.dy = 0.01;
    
    CGPoint point1 = CGPointPlusVector(slingshot.position, lineVector);
    CGPoint point2 = CGPointPlusVector(slingshot.position, CGVectorScale(lineVector, -1));
    
    CGFloat m = (point1.y-point2.y)/(point1.x-point2.x);
    CGFloat b = point1.y-point1.x*m;

    CGFloat x=(self.position.y+self.position.x/m-b)/(m+1/m);
    CGFloat y=m*x+b;
    
    CGPoint inter = CGPointMake(x, y);
    if(CGPointDistance(inter, self.position) <= self.radius ){
        if(MIN(point1.x, point2.x) <= inter.x && inter.x <= MAX(point1.x, point2.x))
            return YES;
    }
    return NO;
}

@end
