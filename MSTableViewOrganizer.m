//
//  HMFTableViewOrganizer.m
//  MA Mobile
//
//  Created by Brandon Butler on 11/1/12.
//  Copyright (c) 2012 POS Management. All rights reserved.
//

#import "HMFTableViewOrganizer.h"

@implementation HMFTableViewOrganizer

+(NSMutableArray *)organizeArrayAlphabetically:(NSMutableArray *)array withSortDescriptor:(NSSortDescriptor *)sortDescriptor withInitialSortDescriptor:(NSSortDescriptor *)initialSortDescriptor {
    
    //This method first sorts the items array then generates a dictionary to create sections for the tableview.
    //(A dictionary was an easy way to ensure that a section was unique)
    //Then sorts those sections (because the dictionary is not based on order we create an array of the keys and actually just sort the keys).
    
    //The items are ALWAYS first sorted by the initial sort descriptor if one exists
    NSArray *sortedArray = (NSMutableArray *)[array sortedArrayUsingDescriptors:@[initialSortDescriptor]];
    
    [array removeAllObjects];
    [array addObjectsFromArray:sortedArray];
    
    //secondary sort
    sortedArray = [array sortedArrayUsingDescriptors:@[sortDescriptor]];
            
    [array removeAllObjects];
    [array addObjectsFromArray:sortedArray];
            
    int currentObject = 0;
    
    //I used a dictionary to store the initial sections because it seemed like an easy way to determine if a section was unique or not.
    NSMutableDictionary *mutableSectionsDictionary = [[NSMutableDictionary alloc] init];
    
    for (id object in array) {

        NSString *sectionHeader = [object valueForKey:[sortDescriptor key]];

        NSNumber *referenceNumber = @(currentObject);
        
        if ([mutableSectionsDictionary objectForKey:sectionHeader] == nil) {
            //This only occurs if there is a new section.
            //objectsInSection is used for each new section.
            //1st object is always the section header name.
            //2nd object onward is a reference to the location of the order in the purchaseOrdersArray
            
            NSMutableArray *objectsInSection = [[NSMutableArray alloc] init];
            [objectsInSection addObject:sectionHeader];
            [objectsInSection addObject:referenceNumber];
            
            [mutableSectionsDictionary setObject:objectsInSection forKey:sectionHeader];
            
            
        } else {
            
            //if a reference for this section already exist we simply add another reference to the purchase order.
            [[mutableSectionsDictionary objectForKey:sectionHeader] addObject:referenceNumber];
        }
        
        currentObject ++;
    }
    
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    
    //The simplest way I found to sort the sections (after sorting the individual items) was to create an array of the keys of the sectionsDictionary and then sort the array and use it to enumerate the sectionsDictionary.
    
    NSMutableArray* sortedKeyArray = [NSMutableArray arrayWithArray:[mutableSectionsDictionary allKeys]];

    [sortedKeyArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    //essentially enumerating the Dictionary but with sorted keys.
    for (id key in sortedKeyArray) {
        
        [sections addObject:[mutableSectionsDictionary objectForKey:key]];
    }
    
    return sections;
  
}

+(NSMutableArray *)organizeArrayChronologically:(NSMutableArray *)array withSortDescriptor:(NSSortDescriptor *)sortDescriptor withInitialSortDescriptor:(NSSortDescriptor *)initialSortDescriptor {
    
    //This method first sorts the items array then generates a dictionary to create sections for the tableview.
    //(A dictionary was an easy way to ensure that a section was unique)
    //Then sorts those sections (because the dictionary is not based on order we create an array of the keys and actually just sort the keys).
    
    //The items are ALWAYS first sorted by the initial sort descriptor if one exists
    NSArray *sortedArray = (NSMutableArray *)[array sortedArrayUsingDescriptors:@[initialSortDescriptor]];
    
    [array removeAllObjects];
    [array addObjectsFromArray:sortedArray];
    
    //secondary sort
    sortedArray = [array sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    [array removeAllObjects];
    [array addObjectsFromArray:sortedArray];
    
    int currentObject = 0;
    
    //I used a dictionary to store the initial sections because it seemed like an easy way to determine if a section was unique or not.
    NSMutableDictionary *mutableSectionsDictionary = [[NSMutableDictionary alloc] init];
    
    for (id object in array) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMMM yyyy"];
        NSString *sectionHeader = [formatter stringFromDate:[object valueForKey:[sortDescriptor key]]];
        
        NSNumber *referenceNumber = @(currentObject);
        
        if ([mutableSectionsDictionary objectForKey:sectionHeader] == nil) {
            //This only occurs if there is a new section.
            //objectsInSection is used for each new section.
            //1st object is always the section header name.
            //2nd object onward is a reference to the location of the order in the purchaseOrdersArray
            
            NSMutableArray *objectsInSection = [[NSMutableArray alloc] init];
            [objectsInSection addObject:sectionHeader];
            [objectsInSection addObject:referenceNumber];
            
            [mutableSectionsDictionary setObject:objectsInSection forKey:sectionHeader];
            
            
        } else {
            
            //if a reference for this section already exist we simply add another reference to the purchase order.
            [[mutableSectionsDictionary objectForKey:sectionHeader] addObject:referenceNumber];
        }
        
        currentObject ++;
    }
    
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    
    //The simplest way I found to sort the sections (after sorting the individual items) was to create an array of the keys of the sectionsDictionary and then sort the array and use it to enumerate the sectionsDictionary.
    
    NSMutableArray* sortedKeyArray = [NSMutableArray arrayWithArray:[mutableSectionsDictionary allKeys]];

    //To sort the section dates I first convert the sortedKeyArray's keys to NSDAtes and store them in a mutableArray.
    //Then I sort the temporary array and place all the keys back into sortedKeyArray
    
    NSMutableArray *tempDateKeyArray = [[NSMutableArray alloc] init];
    
    for (NSString *key in sortedKeyArray) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM yyyy"];
        [tempDateKeyArray addObject:[dateFormatter dateFromString:key]];
    }
    
    [tempDateKeyArray sortUsingSelector:@selector(compare:)];
    
    [sortedKeyArray removeAllObjects];
    
    for (NSDate *key in tempDateKeyArray) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMMM yyyy"];
        [sortedKeyArray addObject:[formatter stringFromDate:key]];
    }
    
    //essentially enumerating the Dictionary but with sorted keys.
    for (id key in sortedKeyArray) {
        
        [sections addObject:[mutableSectionsDictionary objectForKey:key]];
    }
    
    return sections;
    
}

@end
