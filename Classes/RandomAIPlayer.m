//
//  RandomAIPlayer.m
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 2/14/09.
//  Copyright 2009 YUHA. All rights reserved.
//

#import "RandomAIPlayer.h"
#import "Card.h"

@implementation RandomAIPlayer

- (void)willStartTurn:(int)turn round:(int)round {
	Card* card = [self selectCard];
	[self submitCard:card];
}

- (BOOL)isHumanPlayer {
	return NO;
}

- (Card*)selectCard {
	int len = [cards count];
	if (len == 0) { return nil; }
	int idx = random() % len;
	Card* card = [cards objectAtIndex:idx];
	[cards removeObjectAtIndex:idx];
	
	return card;
}

@end
