//
//  CardDeck.h
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 12/6/08.
//  Copyright 2008 YUHA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

#define CARD_NUM 52

@interface CardDeck : NSObject {
	Card* cards[CARD_NUM];
	int order[CARD_NUM];
	int usedCardNum;
}

/**
 * initialize the deck and shuffle it.
 */
- (void)initializeDeck;

/**
 * take the front card of the deck.
 */
- (Card*)takeFront;

/**
 * take the nth card of the deck. This method does not consider order.
 */
- (Card*)peekWithOrder:(int)nth;
- (Card*)peekWithoutOrder:(int)nth;
@end
