//
//  UpcomingViewController.m
//  Sports App Final Project
//
//  Created by Nikhil Raman on 4/21/16.
//  Copyright © 2016 cis195. All rights reserved.
//

#import "UpcomingViewController.h"

@interface UpcomingViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation UpcomingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) loadUpcomingGamesFromNbaApi {
    // TO DO: Implement the gathering of data from the NBA API. Use the nba api url and create a request to gather a listing of a set number of upcoming games
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TO DO: Implement number of rows in section
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TO DO: Implement the desired view for each cell to be displayed
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TO DO: Handle what happens if user taps on a cell
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
