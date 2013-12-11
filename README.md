HMFTableViewOrganizer
====================

Sort an array for use in a tableview

Create a property for HMFTableViewOrganizer.
To initialize it use this convenience method.

```objective-c
self.organizer = [HMFTableViewOrganizer organizerWithArray:myArray];
```

Make sure to use one of the organize methods to sort the array.

```objective-c
[self.organizer organizeAlphabeticallyWwithSortDescriptor:sortDescriptor withInitialSortDescriptor:initialSortDescriptor];

[self.organizer organizeChronologicallyWithSortDescriptor:sortDescriptor withInitialSortDescriptor:initialSortDescriptor];
```
The array will always first be sorted by the initial sort descriptor. (example: invoices get sorted by ID number)
Then it will be sorted by the sortDescriptor (example: invoices then get sorted by customer name)

Sort Descriptors use KVC so you can sort any type of object that is KVC compliant. This is really useful for custom objects.

Then in your tableview datasource methods use this.
```objective-c
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.organizer sectionCount];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.organizer titleForSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.organizer rowCountForSection:section];
}
```

To find the object in self.myDataArray in say... the cellForRowAtIndexPath use...

```objective-c
[self.organizer objectForIndexPath:indexPath];
```

If you need to remove an object from the array you can use this method.
```objective-c
[self. organizer removeObjectAtIndexPath:indexPath];
```
