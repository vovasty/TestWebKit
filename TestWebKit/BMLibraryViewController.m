//
//  xxxxxxxxxx.m
//  TestWebKit
//
//  Created by Vladimir Solomenchuk on 06.06.11.
//  Copyright 2011 none. All rights reserved.
//

#import "BMLibraryViewController.h"
#import "FileSystemUtilities.h"
#import "BMReadController.h"
#import "BMEpub.h"

@implementation BMLibraryViewController

-(void) releaseTopLevelObjects
{
    [mFiles release]; mFiles = nil;
}

- (void)dealloc
{
    [self releaseTopLevelObjects];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

	NSDirectoryEnumerator *filesEnumerator = [[NSFileManager defaultManager] enumeratorAtPath: KADocumentsDirectory()];
	NSString *fileName;
    mFiles = [[NSMutableArray alloc] init];
	while ( ( fileName = [filesEnumerator nextObject] ) ) 
    {
        if ([@"epub" isEqualToString:fileName.pathExtension])
            [mFiles addObject:fileName];
	}
    
    self.title = @"Library";
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseTopLevelObjects];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mFiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [mFiles objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMReadController* readController = [[BMReadController alloc] init];
    [self.navigationController pushViewController:readController animated:YES];
    NSString* path = [KADocumentsDirectory() stringByAppendingPathComponent:[mFiles objectAtIndex:indexPath.row]];
    BMEpub* book = [[BMEpub alloc] initWithFile:path];
    readController.book = book;
    [book release];
    [readController release];
}

@end
