//
//  SBGameScene.h
//  Slingball2
//

//  Copyright (c) 2013 Aaron Kaufer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SBCharacter;

@interface SBGameScene : SKScene

@property (strong) SBCharacter *character;
@property (strong) NSMutableArray *slingshotPool;

@end
