//
//  SBCharacter.m
//  sb2slingshot
//
//  Created by Aaron Kaufer on 9/22/13.
//  Copyright (c) 2013 Aaron Kaufer. All rights reserved.
//

#import "SBCharacter.h"
#import "SBSlingshot.h"

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
    
    
    //self.physicsBody.affectedByGravity = NO;
    
    CGFloat gravity = [(SKScene*)self.parent physicsWorld].gravity.dy;
    SBSlingshot *slingshot = self.attachedSlingshot;

    CGVector dist = CGVectorMake((self.position.x-slingshot.position.x),
                                 (self.position.y-slingshot.position.y));
    
    [self.physicsBody setVelocity:CGVectorMake(dist.dx*gravity*CHARACTER_VELOCITY_TO_PULL_RATIO,
                                               dist.dy*gravity*CHARACTER_VELOCITY_TO_PULL_RATIO)];
    
    CGFloat timeToCenter = fabs((slingshot.position.x-self.position.x)/
                                (dist.dx*gravity*CHARACTER_VELOCITY_TO_PULL_RATIO));
    
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
    if(distanceBetween(pos, self.attachedSlingshot.position) > vectorSize){
        
        CGVector delta = CGVectorMake(pos.x-self.attachedSlingshot.position.x,
                                      pos.y-self.attachedSlingshot.position.y);
        
        float x = vectorSize/CGVectorMagnitude(delta)*(delta.dx);
        float y = vectorSize/CGVectorMagnitude(delta)*(delta.dy);
        
        [super setPosition:CGPointMake(self.attachedSlingshot.position.x + x,
                                       self.attachedSlingshot.position.y + y)];
        
        return;
    }
    
    [super setPosition:pos];
}

@end
