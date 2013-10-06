//
//  SBGameScene.h
//  Slingball2
//

//  Copyright (c) 2013 Aaron Kaufer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SBCharacter;
@class SBSlingshot;

@interface SBGameScene : SKScene

@property (strong) SBCharacter *character;
@property (strong) NSMutableArray *activeSlingshots;
@property (strong) NSMutableArray *slingshotBin;

/* the following is a holder for a physicsbody which the character bounces off of */
@property (strong) SKNode *walls;

-(void)registerTouches:(NSSet *)touches;

-(void)addSlingshot:(SBSlingshot*)slingshot;
-(void)deleteSlingshot:(SBSlingshot*)slingshot;
/* the following deletes a slingshot but adds it to the slingshot bin for future use */
-(void)recycleSlingshot:(SBSlingshot*)slingshot;
/* the following either reuses a slingshot from the slingshot bin, or makes a new one if there is none in the bin */
-(SBSlingshot*)generateSlingshotWithPosition:(CGPoint)pos andLineVector:(CGVector)lineVector;
/* the following calls the above method using random number generation to generate a slingshot */
-(SBSlingshot*)generateRandomSlingshotWithY:(CGFloat)y andMagnitude:(CGFloat)mag;

/* move the objects on the screen down when the character passes halfway */
-(void)adjustScreen;
@end
