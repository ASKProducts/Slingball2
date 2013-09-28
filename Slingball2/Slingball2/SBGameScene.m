//
//  SBGameScene.m
//  Slingball2
//
//  Created by Aaron Kaufer on 9/23/13.
//  Copyright (c) 2013 Aaron Kaufer. All rights reserved.
//

#import "SBGameScene.h"
#import "SBCharacter.h"
#import "SBSlingshot.h"
#import "Definitions.h"

@implementation SBGameScene{
    double previousTime;
}

#pragma mark - initializaing
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        self.physicsWorld.gravity = SCENE_GRAVITY;
        
        
        self.walls = [SKNode node];
        self.walls.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectInset(self.frame, 0, -CHARACTER_RADIUS*100)];
        self.walls.physicsBody.restitution = WALL_RESTITUTION;
        [self addChild:self.walls];
        
        self.character = [[SBCharacter alloc] initWithCircleOfRadius:CHARACTER_RADIUS
                                                        andLineWidth:1
                                                        andFillColor:[UIColor blueColor]
                                                      andStrokeColor:[UIColor whiteColor]];
        self.character.position = CHARACTER_START_POSITION;
        [self addChild:self.character];
        
        self.slingshotBin = [NSMutableArray arrayWithCapacity:1000];
        self.activeSlingshots = [NSMutableArray arrayWithCapacity:1000];
        
        SBSlingshot *first = [self generateSlingshotWithPosition:CHARACTER_START_POSITION
                                                   andLineVector:CGVectorMake(SLINGSHOT_LINE_RADIUS, 0)];
        
        [self addSlingshot:first];
        
        [first attachNode:self.character];
        
        //[self addSlingshot:[self generateRandomSlingshotWithY:200 andMagnitude:SLINGSHOT_LINE_RADIUS]];
        
        //[self addSlingshot:[self generateRandomSlingshotWithY:300 andMagnitude:SLINGSHOT_LINE_RADIUS]];
        
        //[self addSlingshot:[self generateRandomSlingshotWithY:400 andMagnitude:SLINGSHOT_LINE_RADIUS]];
        
        
        
        
        
    }
    return self;
}

#pragma mark - touch handling
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self registerTouches:touches];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self registerTouches:touches];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self registerTouches:touches];
}

-(void)registerTouches:(NSSet *)touches{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        /* dragging and launching the character while in a slingshot */
        if(self.character.attachedSlingshot){
            self.character.position = location;
            if(touch.phase == UITouchPhaseEnded)
                [self.character launch];
        }
        
        if(touch.tapCount == 2 && touch.phase == UITouchPhaseBegan){
            self.anchorPoint = CGPointZero;
            self.character.physicsBody.velocity = CGVectorMake(0, 0);
            self.character.position = CHARACTER_START_POSITION;
            self.walls.position = CGPointZero;
            
            int c = (int)self.activeSlingshots.count;
            for(int i = 0; i < c; i++)
                [self recycleSlingshot:[self.activeSlingshots firstObject]];
            
            
            [self addSlingshot:[self generateSlingshotWithPosition:CGPointMake(self.size.width/2, 100)
                                                     andLineVector:CGVectorMake(SLINGSHOT_LINE_RADIUS, 0)]];
            
        }
    }
}

#pragma mark - adding and deleting
-(void)addSlingshot:(SBSlingshot*)slingshot{
    [self.activeSlingshots addObject:slingshot];
    [self addChild:slingshot];
}
-(void)deleteSlingshot:(SBSlingshot*)slingshot{
    [self.activeSlingshots removeObject:slingshot];
    [slingshot removeFromParent];
    
}
-(void)recycleSlingshot:(SBSlingshot*)slingshot{
    [self deleteSlingshot:slingshot];
    [self.slingshotBin addObject:slingshot];
}
-(SBSlingshot*)generateSlingshotWithPosition:(CGPoint)pos andLineVector:(CGVector)lineVector{
    if(self.slingshotBin.count == 0)
        return [[SBSlingshot alloc] initWithPosition:pos andLineVector:lineVector];
    SBSlingshot *slingshot = [self.slingshotBin lastObject];
    [self.slingshotBin removeLastObject];
    slingshot.position = pos;
    [slingshot updateLineVector:lineVector];
    return slingshot;
}

-(SBSlingshot*)generateRandomSlingshotWithY:(CGFloat)y andMagnitude:(CGFloat)mag{
    CGVector lastVector = [(SBSlingshot*)[self.activeSlingshots lastObject] lineVector];
    CGFloat lastDirection = atan2f(lastVector.dy, lastVector.dx);
    int newDirection = lastDirection-SLINGSHOT_ANGLE_DEVIATION + arc4random()%(SLINGSHOT_ANGLE_DEVIATION*2);
    return [self generateSlingshotWithPosition:CGPointMake(RANDOM(                SLINGSHOT_LINE_RADIUS*2,
                                                                  self.size.width-SLINGSHOT_LINE_RADIUS*2), y)
                                 andLineVector:CGVectorMakeMag(mag, newDirection)];
}




#pragma mark - updates
-(void)update:(CFTimeInterval)currentTime {
    //if(previousTime == 0)previousTime = currentTime;
    //double elapsedTime = currentTime-previousTime;
    
    /* if the character is above 3/5 of the screen, then move the screen down */
    CGFloat relativeY = self.character.position.y + self.anchorPoint.y*self.size.height;
    if(relativeY > CHARACTER_RELATIVE_MAX_HEIGHT){
        CGFloat displacement = relativeY-CHARACTER_RELATIVE_MAX_HEIGHT;
        self.anchorPoint = CGPointMake(self.anchorPoint.x, self.anchorPoint.y - displacement/self.size.height);
        /* the walls can never move */
        self.walls.position = CGPointMake(self.walls.position.x, self.walls.position.y+displacement);
        
    }

    
    NSMutableArray *toRecycle = [NSMutableArray array];
    for (SBSlingshot *slingshot in self.activeSlingshots) {
        /* Attach character to slingshot if necesary */
        if([self.character collidesWithSlingshot:slingshot]){
            [slingshot attachNode:self.character];
        }
        
        /* recycle slingshot if it is below the screen */
        CGRect actualFrame = [slingshot calculateAccumulatedFrame];
        if(actualFrame.origin.y+actualFrame.size.height < self.frame.origin.y){
            [toRecycle addObject:slingshot];
        }
    }
    for (SBSlingshot *slingshot in toRecycle) {
        [self recycleSlingshot:slingshot];
    }
    
    
    SBSlingshot *lastSlingshot = [self.activeSlingshots lastObject];
    CGFloat highestSlingshotY = MAX(CGPointPlusVector(lastSlingshot.position, lastSlingshot.lineVector).y,
                                    CGPointPlusVector(lastSlingshot.position, CGVectorNegate(lastSlingshot.lineVector)).y);
    while (highestSlingshotY < CGRectGetMaxY(self.frame)) {
        [self addSlingshot:[self generateRandomSlingshotWithY:highestSlingshotY+SLINGSHOT_SPACING
                                                 andMagnitude:SLINGSHOT_LINE_RADIUS]];
        lastSlingshot = [self.activeSlingshots lastObject];
        highestSlingshotY = CGPointPlusVector(lastSlingshot.position, lastSlingshot.lineVector).y;
    }
    
    previousTime = currentTime;
}

@end
