//
//  HMFTableViewOrganizer.m
//  MA Mobile
//
//  Created by Brandon Butler on 11/1/12.
//  Copyright (c) 2012 POS Management. All rights reserved.
//

#import "HMFTableViewOrganizer.h"

@interface HMFTableViewOrganizer()

@property (readwrite, nonatomic, strong) NSArray *originalArray;

//stores the titles for each section
@property (nonatomic, strong) NSMutableArray *sectionTitles;

//stores object indexes for each section (for reference to the original Array)
@property (nonatomic, strong) NSMutableArray *sectionReferences;

@end

@implementation HMFTableViewOrganizer

+(instancetype)organizerWithArray:(NSArray *)array {
    return [[self alloc] initWithArray:array];
}

-(id)initWithArray:(NSArray *)array {
    if ((self = [super init])) {
        _originalArray = array;
        _sectionReferences = [NSMutableArray array];
        _sectionTitles = [NSMutableArray array];
    }
    return self;
}

-(void)organizeAlphabeticallyWithSortDescriptor:(NSSortDescriptor *)sortDescriptor withInitialSortDescriptor:(NSSortDescriptor *)initialSortDescriptor {
    
    //This method first sorts the items array then generates a dictionary to create sections for the tableview.
    //(A dictionary was an easy way to ensure that a section was unique)
    //Then sorts those sections (because the dictionary is not based on order we create an array of the keys and actually just sort the keys).
    
    //The items are ALWAYS first sorted by the initial sort descriptor if one exists
    NSMutableArray *sortedArray = [NSMutableArray arrayWithArray:[self.originalArray sortedArrayUsingDescriptors:@[initialSortDescriptor]]];
    
    //secondary sort
    [sortedArray sortUsingDescriptors:@[sortDescriptor]];

    [self organizeAlphabeticallyWithSortDescriptor:sortDescriptor withSortedArray:sortedArray];

}

-(void)organizeChronologicallyWithSortDescriptor:(NSSortDescriptor *)sortDescriptor withInitialSortDescriptor:(NSSortDescriptor *)initialSortDescriptor {
    
    //This method first sorts the items array then generates a dictionary to create sections for the tableview.
    //(A dictionary was an easy way to ensure that a section was unique)
    //Then sorts those sections (because the dictionary is not based on order we create an array of the keys and actually just sort the keys).
    
    //The items are ALWAYS first sorted by the initial sort descriptor if one exists
    NSMutableArray *sortedArray = [NSMutableArray arrayWithArray:[self.originalArray sortedArrayUsingDescriptors:@[initialSortDescriptor]]];
    
    //secondary sort
    [sortedArray sortUsingDescriptors:@[sortDescriptor]];

    [self organizeChronologicalSectionsWithSortDescriptor:sortDescriptor withSortedArray:sortedArray];
    
}

-(void)organizeAlphabeticallyWithSortDescriptor:(NSSortDescriptor *)sortDescriptor withSections:(BOOL)withSections {
    //This method first sorts the items array then generates a dictionary to create sections for the tableview.
    //(A dictionary was an easy way to ensure that a section was unique)
    //Then sorts those sections (because the dictionary is not based on order we create an array of the keys and actually just sort the keys).
    
    //The items are ALWAYS first sorted by the initial sort descriptor if one exists
    NSMutableArray *sortedArray = [NSMutableArray arrayWithArray:[self.originalArray sortedArrayUsingDescriptors:@[sortDescriptor]]];

    if (withSections) {
        [self organizeAlphabeticallyWithSortDescriptor:sortDescriptor withSortedArray:sortedArray];
    } else {
        [self organizeWithoutSections:sortedArray];
    }
}

-(void)organizeChronologicalyWithSortDescriptor:(NSSortDescriptor *)sortDescriptor withSections:(BOOL)withSections {
    
    //This method first sorts the items array then generates a dictionary to create sections for the tableview.
    //(A dictionary was an easy way to ensure that a section was unique)
    //Then sorts those sections (because the dictionary is not based on order we create an array of the keys and actually just sort the keys).
    
    //The items are ALWAYS first sorted by the initial sort descriptor if one exists
    NSMutableArray *sortedArray = [NSMutableArray arrayWithArray:[self.originalArray sortedArrayUsingDescriptors:@[sortDescriptor]]];
    
    if (withSections) {
        [self organizeChronologicalSectionsWithSortDescriptor:sortDescriptor withSortedArray:sortedArray];
    } else {
        [self organizeWithoutSections:sortedArray];
    }
}

-(void)organizeWithoutSections:(NSMutableArray *)sortedArray {
    [self.sectionReferences removeAllObjects];
    NSMutableArray *onlySection = [NSMutableArray arrayWithCapacity:[sortedArray count]];
    for (id object in sortedArray) {
        [onlySection addObject:@([self.originalArray indexOfObject:object])];
    }
    [self.sectionReferences addObject:onlySection];
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObject:@""];
}

-(void)organizeChronologicalSectionsWithSortDescriptor:(NSSortDescriptor *)sortDescriptor withSortedArray:(NSMutableArray *)sortedArray {
    //I used a dictionary to store the initial sections because it seemed like an easy way to determine if a section was unique or not.
    NSMutableDictionary *mutableSectionsDictionary = [[NSMutableDictionary alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM yyyy"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    for (id object in sortedArray) {

        NSString *sectionHeader = [formatter stringFromDate:[object valueForKeyPath:[sortDescriptor key]]];

        NSNumber *referenceNumber = @([self.originalArray indexOfObject:object]);
        
        if ([mutableSectionsDictionary objectForKey:sectionHeader] == nil) {
            //New section.
            
            NSMutableArray *newObjectReferenceArray  = [NSMutableArray arrayWithObject:referenceNumber];
            [mutableSectionsDictionary setObject:newObjectReferenceArray forKey:sectionHeader];
            
        } else {
            
            //if a reference for this section already exist we simply add another reference to the purchase order.
            [[mutableSectionsDictionary objectForKey:sectionHeader] addObject:referenceNumber];
        }
        
    }
    
    //The simplest way I found to sort the sections (after sorting the individual items) was to create an array of the keys of the sectionsDictionary and then sort the array and use it to enumerate the sectionsDictionary.
    
    self.sectionTitles = [NSMutableArray arrayWithArray:[mutableSectionsDictionary allKeys]];
    
    //To sort the section dates I first convert the sortedKeyArray's keys to NSDAtes and store them in a mutableArray.
    //Then I sort the temporary array and place all the keys back into sortedKeyArray
    
    NSMutableArray *tempDateKeyArray = [[NSMutableArray alloc] init];
    
    for (NSString *key in self.sectionTitles) {
        [tempDateKeyArray addObject:[formatter dateFromString:key]];
    }
    
    [tempDateKeyArray sortUsingSelector:@selector(compare:)];
    [self.sectionTitles removeAllObjects];
    
    for (NSDate *key in tempDateKeyArray) {
        [self.sectionTitles addObject:[formatter stringFromDate:key]];
    }
    
    [self.sectionReferences removeAllObjects];
    //essentially enumerating the Dictionary but with sorted keys.
    for (id key in self.sectionTitles) {
        [self.sectionReferences addObject:[mutableSectionsDictionary objectForKey:key]];
    }

}
-(void)organizeAlphabeticallyWithSortDescriptor:(NSSortDescriptor *)sortDescriptor withSortedArray:(NSMutableArray *)sortedArray {
    
    //I used a dictionary to store the initial sections because it seemed like an easy way to determine if a section was unique or not.
    NSMutableDictionary *mutableSectionsDictionary = [NSMutableDictionary dictionary];
    
    for (id object in sortedArray) {
        
        NSString *sectionHeader = [object valueForKeyPath:[sortDescriptor key]];
            
        NSNumber *referenceNumber = @([self.originalArray indexOfObject:object]);
        
        if ([mutableSectionsDictionary objectForKey:sectionHeader] == nil) {
            //If there is a new section.
            NSMutableArray *newObjectReferenceArray  = [NSMutableArray arrayWithObject:referenceNumber];
            [mutableSectionsDictionary setObject:newObjectReferenceArray forKey:sectionHeader];
            
        } else {
            //if a reference for this section already exist we simply add another reference to the purchase order.
            [[mutableSectionsDictionary objectForKey:sectionHeader] addObject:referenceNumber];
        }
        
    }
    
    //The simplest way I found to sort the sections (after sorting the individual items) was to create an array of the keys of the sectionsDictionary and then sort the array and use it to enumerate the sectionsDictionary.
    self.sectionTitles = [NSMutableArray arrayWithArray:[mutableSectionsDictionary allKeys]];
    [self.sectionTitles sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    [self.sectionReferences removeAllObjects];
    //enumerating the Dictionary with sorted keys gives us the section titles organized and an array with the section objectReferences organized.
    for (NSString *key in self.sectionTitles) {
        [self.sectionReferences addObject:[mutableSectionsDictionary objectForKey:key]];
    }
}

-(int)sectionCount {
    return [self.sectionTitles count];
}

-(int)rowCountForSection:(int)section {
    return [[self.sectionReferences objectAtIndex:section] count];
}

-(NSString *)titleForSection:(int)section {
    return [self.sectionTitles objectAtIndex:section];
}

-(id)objectForIndexPath:(NSIndexPath *)indexPath {
    return [self.originalArray objectAtIndex:[self actualIndexForIndexPath:indexPath]];
}

-(void)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
    
    //remove actual object from original array
    NSMutableArray *replacementArray = [NSMutableArray arrayWithArray:self.originalArray];
    [replacementArray removeObjectAtIndex:[self actualIndexForIndexPath:indexPath]];
    self.originalArray = replacementArray;
    
    //create mutable copy of the sectionReference array
    NSMutableArray *sectionReferenceArray = [self.sectionReferences objectAtIndex:indexPath.section];
    
    if ([sectionReferenceArray count] == 1) {
        //if there is only one reference in the sectionReferenceArray remove the sectionReference and sectionTitle.
        [self.sectionTitles removeObjectAtIndex:indexPath.section];
        [self.sectionReferences removeObjectAtIndex:indexPath.section];
    } else {
        //remove the object from the sectionReferenceArray.
        [sectionReferenceArray removeObjectAtIndex:indexPath.row];
    }
}

-(int)actualIndexForIndexPath:(NSIndexPath *)indexPath {
    NSArray *correctSectionArray = [self.sectionReferences objectAtIndex:indexPath.section];
    NSNumber *correctRow = [correctSectionArray objectAtIndex:indexPath.row];
    return [correctRow integerValue];
}

@end
