//
//  Player.h
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 12/5/08.
//  Copyright 2008 YUHA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@class GameViewController;

@interface Player : NSObject {
	int playerId;
	NSString* name;				// player name
	NSMutableArray* cards;		// cards the player has (Card* array)

	GameViewController* gameViewController;
	
	int score[5];				// score of each game
}

@property (nonatomic, assign) int playerId;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) GameViewController* gameViewController;

// ----------------------------------------------------------------------
// alloc/init
- (Player*) initWithName:(NSString*)name;

// ----------------------------------------------------------------------
// property
- (BOOL) isHumanPlayer;

- (int)totalScore;
- (int)getScoreOfRound:(int)round;
- (int*)scores;

// ----------------------------------------------------------------------
// card related

- (void)addCard:(Card*)card;
- (void)removeCard:(Card*)card;
- (void)sortCards;
/** get current cards */
- (NSArray*)getCards;

- (void)submitCard:(Card*)card;

// ----------------------------------------------------------------------
// event handlers

/**
 * called when the game will start.
 * card information and score should be cleared.
 */
- (void)willStartGame;

/**
 * called when the game has started. cards have been distributed.
 */
- (void)didStartGame;

/**
 * called when a turn starts.
 * should call 'submitCard' to submit a card.
 */
- (void)willStartTurn:(int)turn round:(int)round;

/**
 * called when the turn is end. score will be notified to you.
 */
- (void)didEndTurn:(int)turn round:(int)round score:(int)turnScore submittedCards:(NSArray*)submittedCards;

- (void)didEndRound:(int)round winner:(BOOL)winner;

@end



