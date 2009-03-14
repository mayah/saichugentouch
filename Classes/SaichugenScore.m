//
//  SaichugenScore.m
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 12/22/08.
//  Copyright 2008 YUHA. All rights reserved.
//

#import "SaichugenScore.h"

#define SCORE_FILENAME	(@"Documents/score.plist")
#define kNumGames		(@"ngame")
#define kNumWin1		(@"nwin1")
#define kNumWin2		(@"nwin2")
#define kNumDefeat1		(@"ndefeat1")
#define kNumDefeat2		(@"ndefeat2")
#define kNumDraw		(@"ndraw")

@implementation SaichugenScore

@synthesize numGames;
@synthesize numWin1;
@synthesize numWin2;
@synthesize numDefeat1;
@synthesize numDefeat2;
@synthesize numDraw;

// ----------------------------------------------------------------------
// alloc/dealloc

// ----------------------------------------------------------------------
// initializers

- (id)init {
	if (self = [super init]) {
		[self resetScore];
	}
	
	return self;
}

// ----------------------------------------------------------------------
// save/load

+ (SaichugenScore*)loadFromFile {
	SaichugenScore* score = [[[SaichugenScore alloc] init] autorelease];
	
	NSString* plistPath = [NSHomeDirectory() stringByAppendingPathComponent:SCORE_FILENAME];
	NSData* plistData = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	
	NSString* errorDesc = nil;
	NSPropertyListFormat format;
	NSDictionary* dic = (NSDictionary*)[NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListMutableContainersAndLeaves 
					    			    format:&format errorDescription:&errorDesc];
	
	// If error occured, we use initial data.
	if (!dic) {
		NSLog(errorDesc);
		[errorDesc release];
		return score;
	}
	
	score.numGames = [[dic objectForKey:kNumGames] intValue];
	score.numWin1  = [[dic objectForKey:kNumWin1] intValue];
	score.numWin2  = [[dic objectForKey:kNumWin2] intValue];
	score.numDefeat1 = [[dic objectForKey:kNumDefeat1] intValue];
	score.numDefeat2 = [[dic objectForKey:kNumDefeat2] intValue];
	score.numDraw = [[dic objectForKey:kNumDraw] intValue];

	return score;
}

/** save SaichugenScore to the file. YES will be returned if succeeded. */
- (BOOL)saveToFile {
	NSString* errorDesc;
	NSString* plistPath = [NSHomeDirectory() stringByAppendingPathComponent:SCORE_FILENAME];
	
	NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] init];
	[plistDict setValue:[NSNumber numberWithInt:numGames] forKey:kNumGames];
	[plistDict setValue:[NSNumber numberWithInt:numWin1] forKey:kNumWin1];
	[plistDict setValue:[NSNumber numberWithInt:numWin2] forKey:kNumWin2];
	[plistDict setValue:[NSNumber numberWithInt:numDefeat1] forKey:kNumDefeat1];
	[plistDict setValue:[NSNumber numberWithInt:numDefeat2] forKey:kNumDefeat2];
	[plistDict setValue:[NSNumber numberWithInt:numDraw] forKey:kNumDraw];
	
	NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorDesc];
														 
	if (plistData) {
		[plistData writeToFile:plistPath atomically:YES];
		return YES;
	} else {
		NSLog(errorDesc);
		[errorDesc release];
		return NO;
	}
}

- (void)resetScore {
	numGames = numWin1 = numWin2 = numDefeat1 = numDefeat2 = numDraw = 0;
}

// ----------------------------------------------------------------------

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SaichugenScore"];
	if (cell == nil) {
		NSLog(@"Cell was nil");
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"SaichugenScore"] autorelease];
		NSLog(@"Cell should not be nil : %x", cell);
	}
	
	int row = [indexPath row];

    // TODO: HARD CODING STRINGS!
	switch (row) {
		case 0:
			cell.text = [NSString stringWithFormat:@"　　対戦数 : %d", numGames];
			break;
		case 1:
			cell.text = [NSString stringWithFormat:@"一人勝利数 : %d", numWin1];
			break;
		case 2:
			cell.text = [NSString stringWithFormat:@"二人勝利数 : %d", numWin2];
			break;
		case 3:
			cell.text = [NSString stringWithFormat:@"一人敗北数 : %d", numDefeat1];
			break;
		case 4:
			cell.text = [NSString stringWithFormat:@"二人敗北数 : %d", numDefeat2];
			break;
		case 5:
			cell.text = [NSString stringWithFormat:@"引き分け数 : %d", numDraw];
			break;
		default:
			assert(0);
	}
	NSLog(@"switch OK.");
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 6;
}

@end
