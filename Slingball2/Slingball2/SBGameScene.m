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
#import "definitions.h"

@implementation SBGameScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
}

@end
