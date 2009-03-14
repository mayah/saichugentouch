//
//  GameView.h
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 12/16/08.
//  Copyright 2008 YUHA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"

@interface GameView : UIView {
	GameViewController* gameViewController;
	BOOL inCardSelectingMode; // true if card selecting mode. This can be changed to NO when interrupted.
	
}

- (void)setup:(GameViewController*)controller;

- (void)setCardSelectingMode:(BOOL)mode;
+ (CGRect)playerCardRectOfNth:(int)nth;

// ----------------------------------------------------------------------
// private methods
// These methods are private and should not be accessed out of this class.

// redraw cards. 
- (void)redrawCards;
- (void)rearrangeCards;

- (int)cardIndexOfTouchPoint:(CGPoint)point;
@end
