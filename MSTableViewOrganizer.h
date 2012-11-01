//
//  MSTableViewOrganizer.h
//  MA Mobile
//
//  Created by Brandon Butler on 11/1/12.
//  Copyright (c) 2012 POS Management. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSTableViewOrganizer : NSObject

+(NSMutableArray *)organizeArrayAlphabetically:(NSMutableArray *)array withSortDescriptor:(NSSortDescriptor *)sortDescriptor withInitialSortDescriptor:(NSSortDescriptor *)initialSortDescriptor;

+(NSMutableArray *)organizeArrayChronologically:(NSMutableArray *)array withSortDescriptor:(NSSortDescriptor *)sortDescriptor withInitialSortDescriptor:(NSSortDescriptor *)initialSortDescriptor;

@end
