//
//  GameViewController.h
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 12/9/08.
//  Copyright 2008 YUHA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "CardDeck.h"

@class Player;
@class GameView;
@class SaichugenScore;
@class CardMoveController;

/**
 * This class is both a controller of GameView.
 * TODO: This class should not be a game master.
 */
@interface GameViewController : UIViewController {
	// players
	NSArray* players;
	Player* humanPlayer;
	Player* aiPlayer1;
	Player* aiPlayer2;
	
	// card deck
	CardDeck* cardDeck;
	Card* currentRoundCards[3][3]; // playerid, round

	// game status
	int currentRound;
	int currentTurn;
	
	// ---
	IBOutlet CardMoveController* cardMove;
	
	// widgets
    IBOutlet UILabel* leftPlayerNameLabel;
    IBOutlet UILabel* centerPlayerNameLabel;
    IBOutlet UILabel* rightPlayerNameLabel;
	IBOutlet GameView* gameView; // the same as "self.view", but the type is different.
}

@property (nonatomic, readonly, assign) CardDeck* cardDeck;
@property (nonatomic, readonly, assign) NSArray* players;
@property (nonatomic, readonly, assign) Player* humanPlayer;

// ----------------------------------------------------------------------
// CardDeck

- (NSArray*) getHumanCards;

/**
 * set the player name of AI. number should be zero or one.
 */
- (void)setPlayerName:(NSString*)playerName playerNo:(int)number;

/**
 * a player selects a card.
 */
- (void)setCardSelectingMode:(BOOL)mode;

/** move a card to the AI player face position */
- (void)moveCardToAIPlayerPosition:(Card*)card comNo:(int)num;

/** add current turn cards */
- (void)moveCardsToScorePosition:(Card*)humanCard aiPlayer1:(Card*)ai1Card aiPlayer2:(Card*)ai2Card;

/** move card to the center space */
- (void)moveCardsToCenter:(Card*)humanCard aiPlayer1:(Card*)ai1Card aiPlayer2:(Card*)ai2Card;

- (void)redrawCards;

// ----------------------------------------------------------------------
// utility functions

/** calculate scores, and return the middle rank card.*/
- (Card*)fetchScoresOfCards:(int*)outScores cards:(Card**)cards;

/** calculate turn scores. scores will be modified. */
- (void)calcTurnScores:(int*)scores;

// ----------------------------------------------------------------------
// event handlers

- (void)setupGame;
- (void)willStartGame;
- (void)didStartGame;

- (void)willEndGame;

- (void)willStartRound;
- (void)willEndRound;
- (void)didEndRound;

- (void)willStartTurn;
- (void)didSelectCard:(Card*)card player:(int)playerId; // card should not be nil.
- (void)willEndTurn;

@end
