MSTableViewOrganizer
====================

Sort an array for use in a tableview

It works this way...

the sorted array will be organized like this.

Main Array > Section Array > (first object is nsstring for title) - (reference # for object) - (reference # for object) - (etc.)

In other words the section array (that is returned) stores a nsmutablearray for each section. 
The first object in those arrays is a simple nsstring that will be the title.
The next object onwards will be a nsnumber that is a reference to the location in the original array.

So you should have an array of your data. (self.myDataArray)
You also need to create a an array for the sections data that will be returned (self.mySectionsArray)

After you have loaded your data into self.myDataArray you call one of two methods to populate the sections array

```objective-c

self.mySectionsArray = [MSTableViewOrganizer organizeArrayAlphabetically:self.myDataArray withSortDescriptor:sortDescriptor withInitialSortDescriptor:initialSortDescriptor];

self.mySectionsArray = [MSTableViewOrganizer organizeArrayChronologically:self.myDataArray withSortDescriptor:sortDescriptor withInitialSortDescriptor:initialSortDescriptor];

```

The array will always first be sorted by the initial sort descriptor. (example: invoices get sorted by ID number)
Then it will be sorted by the sortDescriptor (example: invoices then get sorted by customer name)

Sort Descriptors use KVC so you can sort any type of object that is KVC compliant. This is really useful for custom objects.

Then in your tableview datasource methods use this.
```objective-c
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.mySections count];
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    //index:0 because first object is always an NSString
    return [[self.mySections objectAtIndex:section] objectAtIndex:0];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //-1 to compensate for extra object at the beginning of the array (the nsstring title for section)
    return [[self.mySections objectAtIndex:section] count] - 1;

}
```

To find the object in self.myDataArray in say... the cellForRowAtIndexPath use...

```objective-c
//+1 because first object is always a NSString for the section title...
[self.myDataArray objectAtIndex:[[[self.mySectionsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row + 1] intValue]]

```