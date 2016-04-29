//
//  UpcomingViewController.m
//  Sports App Final Project
//
//  Created by Nikhil Raman on 4/21/16.
//  Copyright © 2016 cis195. All rights reserved.
//

#import "MlbViewController.h"  
#import "BettingInfoViewController.h" 
#import "GameStatsViewController.h"

#define JsonOddsApiKey @"c423e5a1-c2f0-41b9-91fb-417a57117006" 

#define baseMLBOddsURL @"https://jsonodds.com/api/odds/mlb?oddType=Game"

@interface MlbViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *gamesArray;
@property NSDictionary *singleGameOdds;
@property NSString *homeTeamSelected;
@property NSString *awayTeamSelected;


@end

@implementation MlbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gamesArray = [[NSMutableArray alloc] init];
    [self loadGamesFromMlbApi];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"MLB Schedule";
    
    //UIImage *selectedImage = [UIImage imageNamed:@"Baseball Filled-50.png"];
    //UIImage *unselectedImage = [UIImage imageNamed:@"Baseball-50.png"];
    
    //[self.tabBarItem setImage:unselectedImage];
    //[self.tabBarItem setSelectedImage:selectedImage];
    // Do any additional setup after loading the view.
}

- (void) loadGamesFromMlbApi {
    // TO DO: Implement the gathering of data from the NBA API. Use the nba api url and create a request to gather a listing of a set number of upcoming games
    NSLog(@"Entering MLB game loading");
    NSURL *url = [NSURL URLWithString:baseMLBOddsURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:JsonOddsApiKey forHTTPHeaderField:@"JsonOdds-API-Key"];
    //[request setValue:@"Game" forKey:@"oddType"];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData * data, NSURLResponse *response, NSError *error) {
                    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    //NSArray *games = [[json objectForKey:@"photos"] objectForKey:@"photo"];
                    self.gamesArray = [json mutableCopy];
                    NSLog(@"Obtained MLB data");
                    dispatch_queue_t mainQueue = dispatch_get_main_queue();
                    dispatch_async(mainQueue, ^{
                        [self.tableView reloadData];
                    });
                }] resume];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TO DO: Implement number of rows in section
    return self.gamesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TO DO: Implement the desired view for each cell to be displayed
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mlbGameCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mlbGameCell"];
    }
    
    
    NSDictionary *game = self.gamesArray[indexPath.row];
    NSString *homeTeam = [game objectForKey:@"HomeTeam"];
    UILabel *homeTeamLabel = (UILabel *)[cell viewWithTag:2];
    homeTeamLabel.textColor = [UIColor blueColor];
    homeTeamLabel.text = homeTeam;
    
    NSString *awayTeam = [game objectForKey:@"AwayTeam"];
    UILabel *awayTeamLabel = (UILabel *)[cell viewWithTag:1];
    awayTeamLabel.textColor = [UIColor orangeColor];
    awayTeamLabel.text = awayTeam;
    
    NSString *dateString = [game objectForKey:@"MatchTime"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *gameTime = [dateFormatter dateFromString:dateString];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"EDT"]];
    [dateFormatter setDateFormat:@"MM/dd '|' hh:mm"];
    NSString *newDateString = [dateFormatter stringFromDate:gameTime];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:3];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.text = newDateString;
    
    //[gameTime ]
    
    
    //UILabel *testLabel = (UILabel *)[cell viewWithTag:1];
    //testLabel.text = @"test!";
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TO DO: Handle what happens if user taps on a cell
    NSDictionary *game = self.gamesArray[indexPath.row];
    NSArray *gameOdds = [game objectForKey:@"Odds"];
    self.singleGameOdds = gameOdds[0];
    self.homeTeamSelected = [game objectForKey:@"HomeTeam"];
    self.awayTeamSelected = [game objectForKey:@"AwayTeam"];
    [self performSegueWithIdentifier:@"mlbToOdds" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"mlbToOdds"]) {
        UITabBarController *tbc = (UITabBarController *)segue.destinationViewController;
        BettingInfoViewController *biVC = [tbc.viewControllers objectAtIndex:0];
        biVC.odds = self.singleGameOdds;
        biVC.homeTeamName = self.homeTeamSelected;
        biVC.awayTeamName = self.awayTeamSelected;
        GameStatsViewController *gsVC = [tbc.viewControllers objectAtIndex:1];
        gsVC.homeTeamName = self.homeTeamSelected;
        gsVC.awayTeamName = self.awayTeamSelected;
        gsVC.sport = @"mlb";
    }
    
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
