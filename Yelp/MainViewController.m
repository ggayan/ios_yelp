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
#import "YelpQuery.h"
#import "BusinessCell.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *businesses;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) YelpQuery *query;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Yelp";

    self.query = [YelpQuery new];

    self.searchBar = [UISearchBar new];
    self.searchBar.placeholder = self.query.defaultSearchTerm;

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
    [self updateResults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];

    cell.business = self.businesses[indexPath.row];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Search bar methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.query.searchTerm = searchBar.text;
    [self updateResults];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        [searchBar resignFirstResponder];
        self.query.searchTerm = @"";
        [self updateResults];
    }
}
#pragma mark - Filter delegate methods

- (void)filterViewsController:(FiltersViewController *)filtersViewController didChangeQuery:(YelpQuery *)query {
    self.query = query;
    [self updateResults];
}

#pragma mark - Private methods

- (void)onFilterButton {
    FiltersViewController *vc = [[FiltersViewController alloc] initWithQuery:self.query];
    vc.delegate = self;

    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)configureYelp {

}

- (void)updateResults {
//    NSString *searchTerm = [self.searchBar.text length] > 0 ? self.searchBar.text : self.searchBar.placeholder;
    [self.query executeWithCompletion:^(NSArray *businesses, NSError *error) {
        self.businesses = businesses;
        [self.tableView reloadData];
    }];
}


@end
