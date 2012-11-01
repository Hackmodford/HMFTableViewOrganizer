MSTableViewOrganizer
====================

Sort an array for use in a tableview

It works this way...

the sorted array will be organized like this.

Main Array > Section Array > (first object is nsstring for title) - (reference # for object) - (reference # for object) - (etc.)

In other words the section array (that is returned) stores a nsmutablearray for each section. 
The first object in those arrays is a simle nsstring that will be the title.
The next object onwards will be a nsnumber that is a reference to the location in the original array.

you have an array of your data. (self.myDataArray)
you also have an array for the sections (self.mySectionsArray)

After you have loaded your data into self.myDataArray you call one of two methods

```objective-c

self.mySectionsArray = [MSTableViewOrganizer organizeArrayAlphabetically:self.myDataArray withSortDescriptor:sortDescriptor withInitialSortDescriptor:initialSortDescriptor];

self.mySectionsArray = [MSTableViewOrganizer organizeArrayChronologically:self.myDataArray withSortDescriptor:sortDescriptor withInitialSortDescriptor:initialSortDescriptor];```
```
Then in your tableview datasource methods use this.
```
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.sections count];
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[self.sections objectAtIndex:section] objectAtIndex:0];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.sections objectAtIndex:section] count] - 1;

}
```

To find the object in self.myDataArray in say... the cellForRowAtIndexPath use...

```

[self.myDataArray objectAtIndex:[[[self.mySectionsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row + 1] intValue]]

```