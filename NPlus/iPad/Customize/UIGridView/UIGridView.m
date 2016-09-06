//
//  UIGridViewView.m
//  foodling2
//
//  Created by Tanin Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UIGridView.h"
#import "UIGridViewDelegate.h"
#import "UIGridViewCell.h"
#import "UIGridViewRow.h"

@implementation UIGridView


@synthesize uiGridViewDelegate;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		[self setUp];
    }
    return self;
}


- (id) initWithCoder:(NSCoder *)aDecoder
{
	
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
		self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}


- (void) setUp
{
	self.delegate = self;
	self.dataSource = self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	self.delegate = nil;
	self.dataSource = nil;
	self.uiGridViewDelegate = nil;
    [super dealloc];
}

- (UIGridViewCell *) dequeueReusableCell:(NSString*) name
{
	UIGridViewCell* temp = tempCell;
	tempCell = nil;
    self.identifierName = name;
//    NSLog(@"%@", self.identifierName);
	return temp;
}


// UITableViewController specifics
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (int)[uiGridViewDelegate gridView:self heightForHeaderInSection:(int)section];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (int)[uiGridViewDelegate numberOfSectionsInGridView:self];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return (UIView*)[uiGridViewDelegate gridView:self viewForHeaderInSection:(int)section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    int residue =  ((int)[uiGridViewDelegate gridView:self numberOfRowsInSection:section] % [uiGridViewDelegate numberOfColumnsOfGridView:self]);
	
	if (residue > 0) residue = 1;
	
	return ((int)[uiGridViewDelegate gridView:self numberOfRowsInSection:section] / [uiGridViewDelegate numberOfColumnsOfGridView:self]) + residue;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (int)[uiGridViewDelegate gridView:self heightForRowAt:(int)indexPath.row];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UIGridViewRow";
    CellIdentifier = self.identifierName;
    UIGridViewRow *row = (UIGridViewRow *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (row == nil) {
        row = [[[UIGridViewRow alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	int numCols = (int)[uiGridViewDelegate numberOfColumnsOfGridView:self];
//	int count = (int)[uiGridViewDelegate numberOfCellsOfGridView:self];
    int count = (int)[uiGridViewDelegate gridView:self numberOfRowsInSection:indexPath.section];
	
	CGFloat height = (int)[uiGridViewDelegate gridView:self heightForRowAt:(int)indexPath.row];
    CGFloat width = [uiGridViewDelegate gridView:self widthForColumnAt:(int)indexPath.row];
    CGFloat padding = (self.frame.size.width - numCols * width) / (numCols + 1);
    if (numCols == 1) {
        padding = 0.0f;
    }
	CGFloat x = padding;
	for (int i = 0; i < numCols; i++) {
		if ((i + indexPath.row * numCols) >= count) {
			
			if ([row.contentView.subviews count] > i) {
				((UIGridViewCell *)[row.contentView.subviews objectAtIndex:i]).hidden = YES;
			}
			continue;
		}
		
		if ([row.contentView.subviews count] > i) {
			tempCell = [row.contentView.subviews objectAtIndex:i];
		} else {
			tempCell = nil;
		}
		
		UIGridViewCell *cell = [uiGridViewDelegate gridView:self 
												cellForRowAt:(int)indexPath.row
                                                AndColumnAt:i andSection:(int)indexPath.section];
		if (cell.superview != row.contentView) {
			[cell removeFromSuperview];
			[row.contentView addSubview:cell];
            [cell addTarget:self action:@selector(cellPressed:) forControlEvents:UIControlEventTouchUpInside];
		}
        
		
		cell.hidden = NO;
		cell.rowIndex = (int)indexPath.row;
        cell.sectionIndex = (int)indexPath.section;
		cell.colIndex = i;
        
//		CGFloat thisWidth = [uiGridViewDelegate gridView:self widthForColumnAt:i];
		cell.frame = CGRectMake(x, 0, width, height);
		x += width + padding;
	}
	
	row.frame = CGRectMake(row.frame.origin.x,
							row.frame.origin.y,
							x,
							height);
    return row;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y + scrollView.frame.size.height  > (scrollView.contentSize.height - CELL_HEIGHT_MORE))
    {
        [uiGridViewDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [uiGridViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}


- (IBAction) cellPressed:(id) sender
{
	UIGridViewCell *cell = (UIGridViewCell *) sender;
	[uiGridViewDelegate gridView:self didSelectRowAt:cell.rowIndex AndColumnAt:cell.colIndex andSection:cell.sectionIndex];

}


@end
