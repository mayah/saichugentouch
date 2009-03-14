//
//  CardDeck.m
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 12/6/08.
//  Copyright 2008 YUHA. All rights reserved.
//

#import "CardDeck.h"


@implementation CardDeck

- (id)init {
	if ((self = [super init]) == nil) { return nil; }
	
	for (int i = 0; i < CARD_NUM; ++i) {
		int suit = i / 13;
		int rank = (i % 13) + 1;
		cards[i] = [[Card alloc] initWithSuit:suit withRank:rank];
	}
	[self initializeDeck];
	
	return self;
}

- (void)dealloc {
	for (int i = 0; i < CARD_NUM; ++i) {
		[cards[i] release];
	}
	[super dealloc];
}

- (void)initializeDeck {
	for (int i = 0; i < CARD_NUM; ++i) { order[i] = i; }
	usedCardNum = 0;
	
	// shuffle
	for (int i = CARD_NUM - 1; i >= 0; --i) {
		int idx = random() % (i + 1);
		// swap
		int t = order[i];
		order[i] = order[idx];
		order[idx] = t;		
	}
}

- (Card*)takeFront {
	if (usedCardNum == CARD_NUM) { return nil; }
	return cards[order[usedCardNum++]];
}

- (Card*)peekWithOrder:(int)nth {
	assert(0 <= nth && nth < CARD_NUM);
	return cards[order[nth]];
}

- (Card*)peekWithoutOrder:(int)nth {
	assert(0 <= nth && nth < CARD_NUM);
	return cards[nth];
}

@end
