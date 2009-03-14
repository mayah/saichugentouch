//
//  CardMoveController.m
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 2/14/09.
//  Copyright 2009 YUHA. All rights reserved.
//

#import "Card.h"
#import "CardDeck.h"
#import "CardMoveController.h"
#import "GameView.h"
#import "GameViewController.h"
#import "Player.h"

struct CurrentCards {
	Card* humanCard;
	Card* ai1Card;
	Card* ai2Card;
	
	Card* middleRankCard;
};
static struct CurrentCards gCurrentAnimationCards;

@implementation CardMoveController

- (void)animateDistributingCards {
	// TODO: CardMoveController should not distribute cards.
	NSLog(@"animateDistirubtingCards");
	
	// distribute cards.
	CGRect centerRect;
	centerRect.origin.x = (320 - [Card width]) / 2;
	centerRect.origin.y = (480 - [Card height]) / 2;
	centerRect.size.width = [Card width];
	centerRect.size.height = [Card height];
	
	CardDeck* cardDeck = gameViewController.cardDeck;
	
	// Move All Cards to the center position and show bottom.
	for (int i = 51; i >= 0; --i) {
		Card* card = [cardDeck peekWithOrder:i];
		[[card imageView] removeFromSuperview];
		[card flipToBottom];
		[gameView addSubview:[card imageView]];
		[card imageView].frame = centerRect;
	}
	
	for (int i = 0; i < 3; ++i) {
		for (int j = 0; j < 17; ++j) {
			Player* player = [gameViewController.players objectAtIndex:i];
			Card* card = [cardDeck takeFront];
			[player addCard:card];
			
			[UIView beginAnimations:@"CARD_DISTRIBUTIONS" context:nil];
			[UIView setAnimationDelegate:self];
			if (i == 2 && j == 16) {
				[UIView setAnimationDidStopSelector:@selector(didAnimationOfDistributingCards:finished:context:)];
			}
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDuration:0.3];
			[UIView setAnimationDelay:(i+j*3)*0.02];
			if (i == 1) {
				CGRect frame = [GameView playerCardRectOfNth:j];
				[card imageView].frame = frame;
			} else {
				CGRect frame;
				frame.origin.x = 20 + 88 / 2 - [Card width] / 2;
				frame.origin.y = 82 + 88 / 2 - [Card height] / 2;
				frame.size.width = [Card width];
				frame.size.height = [Card height];
				if (i == 2) { frame.origin.x += 192; }
				[card imageView].frame = frame;
			}
			[UIView commitAnimations];
		}
	}	
}

- (void)didAnimationOfDistributingCards:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	// remove aiPlayers' cards from view.
	NSArray* players = gameViewController.players;
	for (int k = 0; k < [players count]; ++k) {
		Player* player = [players objectAtIndex:k];
		if ([player isHumanPlayer]) { continue; }
		
		NSArray* cards = [player getCards];
		int len = [cards count];
		for (int i = 0; i < len; ++i) {
			Card* card = [cards objectAtIndex:i];
			[[card imageView] removeFromSuperview];
		}
	}
	// remove the last card from the view.
	[[[gameViewController.cardDeck peekWithOrder:51] imageView] removeFromSuperview];
	
	// reveal player cards.
	NSArray* cards = [gameViewController.humanPlayer getCards];
	int len = [cards count];
	for (int i = 0; i < len; ++i) {
		Card* card = [cards objectAtIndex:i];
		[UIView beginAnimations:@"REVEAL_PLAYERS_CARD" context:nil];
		if (i + 1 == len) {
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(didAnimationOfRevealingCards:finished:context:)];
		}
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelay:0.1*i];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:card.imageView cache:NO];
		[card flipToTop];
		[UIView commitAnimations];
	}
}

- (void)didAnimationOfRevealingCards:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	// Sort Player Cards.
	[UIView beginAnimations:@"SORT_PLAYERS_CARD" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didAnimationOfSortingCards:finished:context:)];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	[gameViewController.humanPlayer sortCards];
	[gameView rearrangeCards];
	[UIView commitAnimations];
}

- (void)didAnimationOfSortingCards:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	[gameViewController didStartGame];
}

// ----------------------------------------------------------------------
- (void)animateFlippingCards:(NSArray*)cardsToFlip {

	int len = [cardsToFlip count];
	BOOL first = YES;
	for (int i = 0; i < len; ++i) {
		Card* card = [cardsToFlip objectAtIndex:i];
		if (!card.top) { continue; }
		[UIView beginAnimations:@"CARDS_FLIPS_ON_THE_SCORE_POSITION" context:nil];
		if (first) {
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(didAnimationOfFlippingCardsOnTheScorePosition:finished:context:)];
			first = NO;
		}
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:card.imageView cache:NO];
		[card flipToBottom];
		[UIView commitAnimations];
	}
	
	if (first) {
		// Oops! No cards are animated!
		[self didAnimationOfFlippingCardsOnTheScorePosition:nil	finished:YES context:nil];
	}
}

- (void)didAnimationOfFlippingCardsOnTheScorePosition:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	NSLog(@"didAnimationOfFlippingCardsOnTheScorePosition");
	
	[gameViewController didEndRound];
}

// ----------------------------------------------------------------------

- (void)animateMovingCardToCenter:(NSArray*)cards middleRankCard:(Card*)middleRankCard {
	Card* ai1Card = [cards objectAtIndex:0];
	Card* humanCard = [cards objectAtIndex:1];
	Card* ai2Card = [cards objectAtIndex:2];
	
	gCurrentAnimationCards.humanCard = humanCard;
	gCurrentAnimationCards.ai1Card = ai1Card;
	gCurrentAnimationCards.ai2Card = ai2Card;
	gCurrentAnimationCards.middleRankCard = middleRankCard;
	
	// before animation, move cards to the player face point, and reveal them.
	[ai1Card flipToTop];
	[ai2Card flipToTop];
	[gameViewController moveCardToAIPlayerPosition:ai1Card comNo:0];
	[gameViewController moveCardToAIPlayerPosition:ai2Card comNo:1];	
	
	// move cards to the center.
	[UIView beginAnimations:@"CARD_MOVES_TO_THE_CENTER" context:nil];
	[gameViewController redrawCards];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didAnimationOfMovingCardsToTheCenter:finished:context:)];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	[gameViewController moveCardsToCenter:humanCard aiPlayer1:ai1Card aiPlayer2:ai2Card];
	[UIView commitAnimations];
}

- (void)didAnimationOfMovingCardsToTheCenter:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	// flip the cards.
	[NSThread sleepForTimeInterval:1.0];
	Card* cards[] = { gCurrentAnimationCards.humanCard, gCurrentAnimationCards.ai1Card, gCurrentAnimationCards.ai2Card };
	
	BOOL selected = NO;
	for (int i = 0; i < 3; ++i) {
		if (cards[i] == gCurrentAnimationCards.middleRankCard) { continue; }
		Card* card = cards[i];
		
		[UIView beginAnimations:@"CARDS_FLIPS_ON_THE_CENTER_POSITION" context:nil];
		if (!selected) {
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(didAnimationOfFlippingCardsOnTheCenter:finished:context:)];
			selected = YES;
		}
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:card.imageView cache:NO];
		
		[card flipToBottom];
		
		[UIView commitAnimations];
	}
}

- (void)didAnimationOfFlippingCardsOnTheCenter:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	NSLog(@"didAnimationOfFlippingCardsOnTheCenter");
	
	[UIView beginAnimations:@"CARDS_MOVES_TO_THE_SCORE_POSITION" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didAnimationOfMovingCardsToScorePosition:finished:context:)];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	[gameViewController moveCardsToScorePosition:gCurrentAnimationCards.humanCard aiPlayer1:gCurrentAnimationCards.ai1Card aiPlayer2:gCurrentAnimationCards.ai2Card];
	[UIView commitAnimations];
}

- (void)didAnimationOfMovingCardsToScorePosition:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	[gameViewController willEndTurn];
}

@end
