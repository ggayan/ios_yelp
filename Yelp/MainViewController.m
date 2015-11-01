//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "FiltersViewController.h"
#import "YelpBusiness.h"
#import "BusinessCell.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *businesses;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) NSDictionary *filters;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Yelp";
    self.searchBar = [UISearchBar new];
    self.searchBar.placeholder = @"Restaurants";
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];

    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 116;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];

    self.businesses = @[];
    self.filters = @{@"category_filter": @[]};

    [self updateResults];
}

- (void) updateResults {
    NSString *searchTerm = [self.searchBar.text length] > 0 ? self.searchBar.text : self.searchBar.placeholder;

    [YelpBusiness searchWithTerm:searchTerm
                        sortMode:YelpSortModeBestMatched
                      categories:self.filters[@"category_filter"]
                           deals:NO
                      completion:^(NSArray *businesses, NSError *error) {

                          self.businesses = businesses;
                          [self.tableView reloadData];
                          //
                          //                          for (YelpBusiness *business in businesses) {
                          //                              NSLog(@"%@", business);
                          //                          }
                      }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];

    cell.business = self.businesses[indexPath.row];
    return cell;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"search");
    //    [self updateResults];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"cancel");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Filter delegate methods
- (void)filterViewsController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    self.filters = filters;

    [self updateResults];
}

#pragma mark - Private methods

- (void)onFilterButton {
    FiltersViewController *vc = [FiltersViewController new];
    vc.delegate = self;

    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}


@end
