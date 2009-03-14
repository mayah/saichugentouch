//
//  GameView.m
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 12/16/08.
//  Copyright 2008 YUHA. All rights reserved.
//

#import "GameView.h"
#import "Card.h"
#import "SaichugenTouchAppUtility.h"
#import "Player.h"

@implementation GameView

// ----------------------------------------------------------------------
// alloc/dealloc

- (void) dealloc {
    [super dealloc];
}

// ----------------------------------------------------------------------
// initializers

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)setup:(GameViewController*)controller {
	inCardSelectingMode = NO;
	gameViewController = controller;
}

// ----------------------------------------------------------------------
// 

- (void) drawRect:(CGRect)rect {
    // Drawing code
}

- (void) redrawCards {
	NSArray* playerCards = [gameViewController getHumanCards];
	int len = [playerCards count];
	for (int i = 0; i < len; ++i) {
		Card* card = [playerCards objectAtIndex:i];
		[card flipToTop];
		
		UIView* view = [card imageView];
		view.frame = [GameView playerCardRectOfNth:i];
	}
}

- (void)rearrangeCards {
	NSArray* playerCards = [gameViewController getHumanCards];
	int len = [playerCards count];
	for (int i = 0; i < len; ++i) {
		Card* card = [playerCards objectAtIndex:i];
		
		UIView* view = [card imageView];
		view.frame = [GameView playerCardRectOfNth:i];
	}
}

+ (CGRect)playerCardRectOfNth:(int)nth {
	CGRect frame;
	frame.origin.x = 11 + [Card width] * (nth % 9);
	frame.origin.y = 352 + [Card height] * (nth / 9);
	frame.size.width = [Card width];
	frame.size.height = [Card height];
	
	return frame;
}

- (int)cardIndexOfTouchPoint:(CGPoint)point {
	NSArray* playerCards = [gameViewController getHumanCards];
	
	if (point.x < 11) { return -1; }
	if (point.y < 348) { return -1; }
	int dx = (point.x - 11) / [Card width];
	int dy = (point.y - 348) / [Card height];
	if (dx >= 9) { return -1; }
	
	int idx = dx + dy * 9;

	if (idx < [playerCards count]) { return idx; }
	else { return -1; }
}

- (void)setCardSelectingMode:(BOOL)mode {
	NSLog(@"setCardSelectingMode:%d", mode);
	inCardSelectingMode = mode;
}

// ----------------------------------------------------------------------
// touch events

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	NSLog(@"touchesBegan is called.");
	
	if (!inCardSelectingMode) { return; }
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	NSLog(@"touchesMoved is called.");
	
	if (!inCardSelectingMode) { return; }
}


- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	NSLog(@"touchesEnded is called.");
	
	if (!inCardSelectingMode) { return; }
	NSArray* playerCards = [gameViewController getHumanCards];
	
	UITouch* touch = [touches anyObject];
	CGPoint loc = [touch locationInView:self];
	int x = [self cardIndexOfTouchPoint:loc];
	
	NSLog(@"CardSelected: %d", x);
	if (x != -1) {
		Card* selectedCard = [playerCards objectAtIndex:x];
		if (selectedCard.highlighting) {
			[selectedCard highlight:NO];
			[gameViewController.humanPlayer removeCard:selectedCard];
			[gameViewController didSelectCard:selectedCard player:1]; // TODO: MAGIC NUMBER! 1 is HUMAN_PLAYER_ID

			inCardSelectingMode = NO;
		} else {
			for (int i = 0; i < [playerCards count]; ++i) {
				[[playerCards objectAtIndex:i] highlight:NO];
			}
			[selectedCard highlight:YES];
		}
	} else {
		for (int i = 0; i < [playerCards count]; ++i) {
			[[playerCards objectAtIndex:i] highlight:NO];
		}
	}
}


- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
	NSLog(@"touchesCancelled is called.");
	
	if (!inCardSelectingMode) { return; }
}


@end
