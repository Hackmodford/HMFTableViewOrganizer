//
//  HMFTableViewOrganizer.h
//  MA Mobile
//
//  Created by Brandon Butler on 11/1/12.
//  Copyright (c) 2012 POS Management. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMFTableViewOrganizer : NSObject

+(instancetype)organizerWithArray:(NSArray *)array;

-(void)organizeAlphabeticallyWithSortDescriptor:(NSSortDescriptor *)sortDescriptor withInitialSortDescriptor:(NSSortDescriptor *)initialSortDescriptor;

-(void)organizeChronologicallyWithSortDescriptor:(NSSortDescriptor *)sortDescriptor withInitialSortDescriptor:(NSSortDescriptor *)initialSortDescriptor;

-(int)sectionCount;
-(int)rowCountForSection:(int)section;
-(NSString *)titleForSection:(int)section;
-(id)objectForIndexPath:(NSIndexPath *)indexPath;
-(void)removeObjectAtIndexPath:(NSIndexPath *)indexPath;

@end
