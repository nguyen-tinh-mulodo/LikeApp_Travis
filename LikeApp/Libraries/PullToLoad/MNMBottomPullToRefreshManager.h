

@class MNMBottomPullToRefreshView;
@class MNMBottomPullToRefreshManager;

#import <Foundation/Foundation.h>

/**
 * Delegate protocol to implement by MNMBottomPullToRefreshManager observers to track and manage pull-to-refresh view behavior.
 */
@protocol MNMBottomPullToRefreshManagerClient

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager;

@end

#pragma mark -

/**
 * Manager that plays Mediator role and manages relationship between pull-to-refresh view and its associated table. 
 */
@interface MNMBottomPullToRefreshManager : NSObject

/**
 * Initializes the manager object with the information to link the view and the table.
 *
 * @param height The height that the pull-to-refresh view will have.
 * @param table Table view to link pull-to-refresh view to.
 * @param client The client that will observe behavior.
 */
- (id)initWithPullToRefreshViewHeight:(CGFloat)height tableView:(UICollectionView *)table withClient:(id<MNMBottomPullToRefreshManagerClient>)client;

/**
 * Relocate pull-to-refresh view at the bottom of the table taking into account the frame and the content offset.
 */
- (void)relocatePullToRefreshView;

/**
 * Sets the pull-to-refresh view visible or not. Visible by default.
 *
 * @param visible YES to make visible.
 */
- (void)setPullToRefreshViewVisible:(BOOL)visible;

/**
 * Has to be called when the table is being scrolled. Checks the state of control depending on the offset of the table.
 */
- (void)tableViewScrolled;

/**
 * Has to be called when table dragging ends. Checks the triggering of the refresh.
 */
- (void)tableViewReleased;

/**
 * Indicates that the reload of the table is completed. Resets the state of the view to Idle.
 */
- (void)tableViewReloadFinished;

@end
