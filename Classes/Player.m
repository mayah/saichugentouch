//
//  Player.m
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 12/5/08.
//  Copyright 2008 YUHA. All rights reserved.
//

#import <assert.h>
#import "Player.h"
#import "GameViewController.h"

@implementation Player

@synthesize playerId;
@synthesize name;
@synthesize gameViewController;

//----------------------------------------------------------------------
// alloc/init

- (Player*)initWithName:(NSString*)playerName {
	if ((self = [self init]) != nil) {
		self.name = playerName;
		cards = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)dealloc {
	[cards dealloc];
	[super dealloc];
}

//----------------------------------------------------------------------
// 

- (BOOL) isHumanPlayer {
	// should be overriden.
	[self doesNotRecognizeSelector:_cmd];
	
	return NO;
}

//----------------------------------------------------------------------
// Event handlers

- (void)willStartGame {
	// Clear cards;
	[cards removeAllObjects];
	
	// Clear score
	for (int i = 0; i < 5; ++i) {
		score[i] = 0;
	}
}

- (void)didStartGame {
	// DO NOTHING.
}

- (void)willStartTurn:(int)turn round:(int)round {
	// DO NOTHING
}

- (void)addCard:(Card*)card {
	[cards addObject:card];
}

- (void)removeCard:(Card*)card {
	[cards removeObject:card];
}

- (void)sortCards {
	[cards sortUsingSelector:@selector(compare:)];
}

- (NSArray*)getCards {
	return cards;
}

- (int)totalScore {
	int sum = 0;
	for (int i = 0; i < 5; ++i) {
		sum += score[i];
	}
	return sum;
}

- (int)getScoreOfRound:(int)round {
	return score[round - 1];
}

- (int*)scores; {
	return score;
}

- (void)didEndTurn:(int)turn round:(int)round score:(int)turnScore submittedCards:(NSArray*)submittedCards {
	score[round - 1] += turnScore;
}

- (void)didEndRound:(int)round winner:(BOOL)winner {
	if (!winner) {
		score[round - 1] = 0;
	}
}

- (void)submitCard:(Card*)card {
	[gameViewController didSelectCard:card player:playerId];
}

@end

