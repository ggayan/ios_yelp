//
//  FilterViewController.h
//  Yelp
//
//  Created by Gabriel Gayan on 15/31/10.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpQuery.h"

@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>

- (void)filterViewsController:(FiltersViewController *)filtersViewController didChangeQuery:(YelpQuery *)query;

@end

@interface FiltersViewController : UIViewController

@property (nonatomic, weak) id<FiltersViewControllerDelegate> delegate;
@property (nonatomic) YelpQuery *query;

- (id)initWithQuery:(YelpQuery *)query;

@end
