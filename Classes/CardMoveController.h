//
//  CardMoveController.h
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 2/14/09.
//  Copyright 2009 YUHA. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GameViewController;
@class GameView;

/**
 * CardMoveController is a utility class for animating cards.
 */
@interface CardMoveController : NSObject {
	IBOutlet GameViewController* gameViewController;
	IBOutlet GameView* gameView;
}

// --- animation for distributing cards.
- (void)animateDistributingCards;
- (void)didAnimationOfDistributingCards:(NSString *)animationID finished:(BOOL)finished context:(void*)context;
- (void)didAnimationOfRevealingCards:(NSString *)animationID finished:(BOOL)finished context:(void*)context;
- (void)didAnimationOfSortingCards:(NSString *)animationID finished:(BOOL)finished context:(void*)context;

// --- animation for flipping cards
- (void)animateFlippingCards:(NSArray*)cardsToFlip;
- (void)didAnimationOfFlippingCardsOnTheScorePosition:(NSString *)animationID finished:(BOOL)finished context:(void *)context;


// --- animation for submitting cards.
- (void)animateMovingCardToCenter:(NSArray*)cards middleRankCard:(Card*)middleRankCard;
- (void)didAnimationOfMovingCardsToTheCenter:(NSString *)animationID finished:(BOOL)finished context:(void *)context;
- (void)didAnimationOfFlippingCardsOnTheCenter:(NSString *)animationID finished:(BOOL)finished context:(void *)context;
- (void)didAnimationOfMovingCardsToScorePosition:(NSString *)animationID finished:(BOOL)finished context:(void *)context;

@end
