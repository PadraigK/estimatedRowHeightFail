# estimatedRowHeightFail
Example project for Radars: [20829237](http://www.openradar.me/20829237) 
and [20829131](http://www.openradar.me/20829131)

### `scrollToRowAtIndexPath:atScrollPosition:animated:` is broken when using `estimatedRowHeight` (20829131)

Summary:
If a tableView uses estimatedRowHeight, scrollToRowAtIndexPath:atScrollPosition:animated will 
not scroll to the correct location in the tableview.

Steps to Reproduce:

1. Create a table with lots of cells. 
2. Provide an `estimatedRowHeight`
3. Implement `tableView:heightForRowAtIndexPath:` and return a different value than `estimatedRowHeight`
4. Call `scrollToRowAtIndexPath:atScrollPosition:animated` to go to the last cell

Expected Results:

You should now be at the bottom of the table.

Actual Results:

If the total for all estimated heights is > actual heights, we zoom past the end 
and get a blank screen. If the total for all estimated heights is < actual heights, 
we don't reach the end — the scroller is not 100% of the way.
    
The results differ between `animated` being YES or NO, but neither behaviour correct 
puts the cell onscreen.

### Scrolling back up on a tableView that uses `estimatedRowHeight` flickers wildly. (20829237)

Summary:
When using `estimatedRowHeight` and scrolling quickly past a cell that never gets its 
`heightForRowAtIndexPath` called, some cells that are drawn when scrolling back up flicker 
wildly.

Steps to Reproduce:

1. Create a table with lots of cells. 
2. Provide an `estimatedRowHeight`
3. Implement `tableView:heightForRowAtIndexPath:` and return a different value than `estimatedRowHeight`
4. Call `scrollToRowAtIndexPath:atScrollPosition:animated` to go to the last cell
5. It'll end up halfway down the table thanks to radar 20829131, but that's fine for now.
6. Using your finger, start slowly scrolling back up towards the top of the table.

Expected Results:
The tableview cells should draw smoothly as you scroll back up.

Actual Results:
1. After scrolling 10-15 cells the cells all suddenly jump and scroll much faster than they should be.
2. Things settle down and are normal again until you scroll up another 10 or so cells...

Notes:
Manually scrolling fast enough to skip a cell causes this too, but the scrollToRowAtIndexPath method 
here illustrates it easiest. The wider the difference between estRowHeight and actualHeight, the worse 
this gets — it is noticeable even with 5pt differences though.
