//
//  GameViewController.m
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 12/9/08.
//  Copyright 2008 YUHA. All rights reserved.
//

#import "GameViewController.h"
#import "GameView.h"
#import "SaichugenTouchAppUtility.h"
#import "SaichugenTouchViewController.h"
#import "SaichugenScore.h"
#import "CardDeck.h"
#import "Card.h"
#import "CardMoveController.h"
#import "Player.h"
#import "RandomAIPlayer.h"
#import "HumanPlayer.h"

@implementation GameViewController

@synthesize cardDeck;
@synthesize players;
@synthesize humanPlayer;

// ----------------------------------------------------------------------
// alloc/dealloc

- (void)dealloc {
	[players release];
	[cardDeck release];
	[humanPlayer release];
	[aiPlayer1 release];
	[aiPlayer2 release];
    [super dealloc];
}

// ----------------------------------------------------------------------
// initialize

/*
// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
	humanPlayer = [[HumanPlayer alloc] initWithName:@"YOU"];
	humanPlayer.gameViewController = self;
	humanPlayer.playerId = 1;
	aiPlayer1 = [[RandomAIPlayer alloc] initWithName:@"COM 1"];
	aiPlayer1.gameViewController = self;
	aiPlayer1.playerId = 0;
	aiPlayer2 = [[RandomAIPlayer alloc] initWithName:@"COM 2"];
	aiPlayer2.gameViewController = self;
	aiPlayer2.playerId = 2;
	
	players = [[NSArray arrayWithObjects:aiPlayer1, humanPlayer, aiPlayer2, nil] retain];
	
	cardDeck = [[CardDeck alloc] init];
	
	currentRound = 0;
	currentTurn = 0;
	
    [super viewDidLoad];
	[gameView setup:self];
}

/*
 // Implement ; to create a view hierarchy programmatically.
 - (void)loadView {
 }
 */

// ----------------------------------------------------------------------
// 

- (NSArray*) getHumanCards {
	return [humanPlayer getCards];
}

- (void)setPlayerName:(NSString*)playerName playerNo:(int)number {
    switch (number) {
        case 0:
            leftPlayerNameLabel.text = playerName;
            break;
        case 1:
            centerPlayerNameLabel.text = playerName;
            break;
        case 2:
            rightPlayerNameLabel.text = playerName;
            break;
        default:
            assert(0);
            break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)setCardSelectingMode:(BOOL)mode {
	[gameView setCardSelectingMode:mode];
}

- (void)moveCardToAIPlayerPosition:(Card*)card comNo:(int)num {
	assert(num == 0 || num == 1);
	
	int w = [Card width];
	int h = [Card height];
	
	CGRect frame;
	frame.origin.x = 20 + 88 / 2 - w / 2;
	frame.origin.y = 80 + 88 / 2 - h / 2;
	frame.size.width = w;
	frame.size.height = h;
	
	if (num == 1) { frame.origin.x += 192; }
	
	[self.view addSubview:[card imageView]];
	[card imageView].frame = frame;
}

- (void)moveCardsToCenter:(Card*)humanCard aiPlayer1:(Card*)ai1Card aiPlayer2:(Card*)ai2Card {
	int w = [Card width];
	int h = [Card height];
	
	CGRect frame;
	frame.origin.x = 64 - w / 2;
	frame.origin.y = 300;
	frame.size.width = w;
	frame.size.height = h;
	
	[self.view addSubview:[ai1Card imageView]];
	[ai1Card imageView].frame = frame;
	
	frame.origin.x += 96;
	[self.view addSubview:[humanCard imageView]];
	[humanCard imageView].frame = frame;
	
	frame.origin.x += 96;
	[self.view addSubview:[ai2Card imageView]];
	[ai2Card imageView].frame = frame;
}

- (void)moveCardsToScorePosition:(Card*)humanCard aiPlayer1:(Card*)ai1Card aiPlayer2:(Card*)ai2Card {
	int turn = currentTurn - 1;
	int round = currentRound - 1;

	int w = [Card width];
	int h = [Card height];
	
	CGRect frame;
	frame.origin.x = 20 + (w - 4) * turn;
	frame.origin.y = 173 + (h - 30) * round;
	frame.size.width = w;
	frame.size.height = h;
	
	[self.view addSubview:[ai1Card imageView]];
	[ai1Card imageView].frame = frame;
	
	frame.origin.x += 96;
	[self.view addSubview:[humanCard imageView]];
	[humanCard imageView].frame = frame;
	
	frame.origin.x += 96;
	[self.view addSubview:[ai2Card imageView]];
	[ai2Card imageView].frame = frame;
}

- (void)redrawCards {
	[gameView redrawCards];
}

// ----------------------------------------------------------------------
// utility functions

- (Card*)fetchScoresOfCards:(int*)outScores cards:(Card**)cards {
	int ids[] = {[cards[0] cardID], [cards[1] cardID], [cards[2] cardID]};
	
	// Check which card is the middle rank.
	if ((ids[1] < ids[0] && ids[0] < ids[2]) || (ids[2] < ids[0] && ids[0] < ids[1])) {
		// humanCard is the middle
		outScores[0] = cards[0].rank;
		outScores[1] = 0;
		outScores[2] = 0;
		return cards[0];
	} else if ((ids[2] < ids[1] && ids[1] < ids[0]) || (ids[0] < ids[1] && ids[1] < ids[2])) {
		outScores[0] = 0;
		outScores[1] = cards[1].rank;
		outScores[2] = 0;
		return cards[1];
	} else if ((ids[0] < ids[2] && ids[2] < ids[1]) || (ids[1] < ids[2] && ids[2] < ids[0])) {
		outScores[0] = 0;
		outScores[1] = 0;
		outScores[2] = cards[2].rank;
		return cards[2];
	}
	
	assert(false);
	return nil;
}

- (void)calcTurnScores:(int*)scores {
	BOOL preserve[3];
	for (int i = 0; i < 3; ++i) {
		int prev = (i - 1 + 3) % 3;
		int succ = (i + 1) % 3;
		
		if (scores[prev] <= scores[i] && scores[i] <= scores[succ] ||
			scores[succ] <= scores[i] && scores[i] <= scores[prev]) {
			preserve[i] = YES;
		} else {
			preserve[i] = NO;
		}
	}
	
	for (int i = 0; i < 3; ++i) {
		if (!preserve[i]) {
			scores[i] = 0;
		}
	}
}


// ----------------------------------------------------------------------
// event handlers

- (void)setupGame {
	// set player name
    for (int i = 0; i < [players count]; ++i) {
        Player* player = [players objectAtIndex:i];
        [self setPlayerName:player.name playerNo:i];
    }
	
	// set title
	self.title = NSLocalizedString(@"Distributing", @"distributing");

	// initialize deck.
	[cardDeck initializeDeck];

	// initialize the view of each card.
	for (int i = 0; i < CARD_NUM; ++i) {
		Card* card = [cardDeck peekWithoutOrder:i];
		[card flipToTop];
		[card highlight:NO];
		[[card imageView] removeFromSuperview];
	}
}

- (void)willStartGame {
	NSLog(@"Called willStartGame");
	
	currentRound = 0;
	currentTurn = 0;
		
	for (int i = 0; i < 3; ++i) {
		Player* player = [players objectAtIndex:i];
		[player willStartGame];
	}
	
	[cardMove animateDistributingCards];
}

- (void)didStartGame {
	NSLog(@"didStartGame");
	
	for (int i = 0; i < 3; ++i) {
		Player* player = [players objectAtIndex:i];
		[player didStartGame];
	}
	
	[self willStartRound];
}
// ----------------------------------------------------------------------

- (void)willStartRound {
	NSLog(@"onStartRound");
	
	currentRound += 1;
	currentTurn = 0;
	
	for (int i = 0; i < 3; ++i) {
		for (int j = 0; j < 3; ++j) {
			currentRoundCards[i][j] = nil;
		}
	}
	
	[self willStartTurn];
}

- (void)willStartTurn {
	NSLog(@"onStartTurn");
	currentTurn += 1;
	
	// set title
	self.title = [NSString stringWithFormat:@"Round %d : Turn %d", currentRound, currentTurn];
	
	// the player should choose a card.
	for (int i = 0; i < [players count]; ++i) {
		Player* player = [players objectAtIndex:i];
		[player willStartTurn:currentTurn round:currentRound];
	}
}

- (void)didSelectCard:(Card*)card player:(int)playerId {
	assert(0 <= playerId && playerId <= 2);
	assert(card); // card should not be nil.

	@synchronized (self) {
		currentRoundCards[playerId][currentTurn - 1] = card;

		if (currentRoundCards[0][currentTurn - 1] == nil ||
			currentRoundCards[1][currentTurn - 1] == nil ||
			currentRoundCards[2][currentTurn - 1] == nil) {
			return;
		}
	}
	
	Card* ai1Card   = currentRoundCards[0][currentTurn - 1];
	Card* humanCard = currentRoundCards[1][currentTurn - 1];
	Card* ai2Card   = currentRoundCards[2][currentTurn - 1];
	Card* middleRankCard = nil;
	
	NSArray* submittedCards = [NSArray arrayWithObjects:ai1Card, humanCard, ai2Card, nil];
	
	// TODO: use utility function!
	// Check which card is the middle rank.
	int ids[] = {[humanCard cardID], [ai1Card cardID], [ai2Card cardID]};
	if ((ids[1] < ids[0] && ids[0] < ids[2]) || (ids[2] < ids[0] && ids[0] < ids[1])) {
		// humanCard is the middle
		middleRankCard = humanCard;
		[humanPlayer didEndTurn:currentTurn round:currentRound score:humanCard.rank submittedCards:submittedCards];
		[aiPlayer1   didEndTurn:currentTurn round:currentRound score:0 submittedCards:submittedCards];
		[aiPlayer2   didEndTurn:currentTurn round:currentRound score:0 submittedCards:submittedCards];
	} else if ((ids[2] < ids[1] && ids[1] < ids[0]) || (ids[0] < ids[1] && ids[1] < ids[2])) {
		// ai1 is the middle
		middleRankCard = ai1Card;
		[humanPlayer didEndTurn:currentTurn round:currentRound score:0 submittedCards:submittedCards];
		[aiPlayer1   didEndTurn:currentTurn round:currentRound score:ai1Card.rank submittedCards:submittedCards];
		[aiPlayer2   didEndTurn:currentTurn round:currentRound score:0 submittedCards:submittedCards];
	} else if ((ids[0] < ids[2] && ids[2] < ids[1]) || (ids[1] < ids[2] && ids[2] < ids[0])) {
		// ai2 is the middle
		middleRankCard = ai2Card;
		[humanPlayer didEndTurn:currentTurn round:currentRound score:0 submittedCards:submittedCards];
		[aiPlayer1   didEndTurn:currentTurn round:currentRound score:0 submittedCards:submittedCards];
		[aiPlayer2   didEndTurn:currentTurn round:currentRound score:ai2Card.rank submittedCards:submittedCards];
	}
	
	[cardMove animateMovingCardToCenter:submittedCards middleRankCard:middleRankCard];
}

- (void)willEndTurn {
	if (currentTurn == 3) {
		[self willEndRound];
	} else {
		[self willStartTurn];
	}
}

- (void)willEndRound {
	int scores[3];
	for (int i = 0; i < [players count]; ++i) {
		Player* player = [players objectAtIndex:i];
		scores[i] = [player getScoreOfRound:currentRound];
	}
	
	NSMutableArray* cardsToFlip = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < [players count]; ++i) {
		Player* player = [players objectAtIndex:i];
		int prev = (i - 1 + [players count]) % [players count];
		int succ = (i + 1) % [players count];
		
		if (scores[prev] <= scores[i] && scores[i] <= scores[succ] ||
			scores[succ] <= scores[i] && scores[i] <= scores[prev]) {
			[player didEndRound:currentRound winner:YES];
		} else {
			[player didEndRound:currentRound winner:NO];
			for (int j = 0; j < 3; ++j) {
				[cardsToFlip addObject:currentRoundCards[i][j]];
			}
		}
	}
	
	[cardMove animateFlippingCards:cardsToFlip];	
}

- (void)didEndRound {
	if (currentRound == 5) {
		[self willEndGame];
	} else {
		[self willStartRound];
	}
}

- (void)willEndGame {
	NSLog(@"onEndGame");
	
	int scores[3] = {[humanPlayer totalScore], [aiPlayer1 totalScore], [aiPlayer2 totalScore]};
	BOOL wins[3] = { NO, NO, NO };
	
	if ((scores[1] <= scores[0] && scores[0] <= scores[2]) || (scores[2] <= scores[0] && scores[0] <= scores[1])) {
		wins[0] = YES;
	}
	if ((scores[2] <= scores[1] && scores[1] <= scores[0]) || (scores[0] <= scores[1] && scores[1] <= scores[2])) {
		wins[1] = YES;
	}
	if ((scores[0] <= scores[2] && scores[2] <= scores[1]) || (scores[1] <= scores[2] && scores[2] <= scores[0])) {
		wins[2] = YES;
	}

	int numWinner = 0;
	for (int i = 0; i < 3; ++i) {
		if (wins[i]) { ++numWinner; }
	}
	
	SaichugenScore* score = getDelegate().score;
	NSLog(@"score : numGames : %d", score.numGames);
	score.numGames += 1;
	if (numWinner == 3) {
		score.numDraw += 1;
	} else if (numWinner == 2) {
		if (wins[0]) { 
			score.numWin2 += 1;
		} else {
			score.numDefeat1 += 1;
		}
	} else if (numWinner == 1) {
		if (wins[0]) {
			score.numWin1 += 1;
		} else {
			score.numDefeat2 += 1;
		}
	} else {
		assert(false);
	}
	NSLog(@"score : numGames : %d", score.numGames);
	
	NSString* title;
	if (wins[0]) {
		title = @"YOU WIN";
	} else {
		title = @"YOU LOSE";
	}
	
	// TODO: HARD CORDING!!
	NSString* str = [NSString stringWithFormat:@"YOU: %d COM 1: %d COM 2: %d", scores[0], scores[1], scores[2]];
	
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil]; 
	[alertView show];
}

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[alertView release];
	
	// return to the HOME
	[getDelegate().viewController onGameHOMEButtonPressed:nil];	
}


@end
