//
//  NicknameVC.m
//  BPCollage
//
//  Created by Administrator on 08.08.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "NicknameVC.h"
#import "Photo.h"
#import "BestCollectionVC.h"

@interface NicknameVC ()<NSURLSessionDownloadDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nickname;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (strong,nonatomic) NSMutableArray *photos;
@property (strong,nonatomic) NSString *name;
@end

@implementation NicknameVC

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{

}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}

///////////////////////////////////
-(NSString *)name
{
    if (!_name) {
        _name=[[NSString alloc]init];
    }
    return _name;
}

-(NSMutableArray *)photos
{
    if (!_photos) {
        _photos=[[NSMutableArray alloc]init];
    }
    return _photos;
}

- (IBAction)clickCreate:(id)sender
{
    [self textFieldShouldReturn:self.nickname];
    if ([self.nickname.text length]) {
        NSLog(@"%@ - %@",self.nickname.text,self.name);
        if ([self.nickname.text isEqualToString:self.name]) {
            
        }else{
            self.photos=nil;
            self.name=nil;
            [self fetchUser];
        }
    }else{
        [self cancelWithAlert:4];
    }

    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nickname.delegate=self;
    self.spinner.hidden=YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PushToCollection"]) {
        if ([segue.destinationViewController isKindOfClass:[BestCollectionVC class]]){
            BestCollectionVC *bcvc=(BestCollectionVC *)segue.destinationViewController;
            bcvc.photos=[self sortedPhotosByPopularity];
        }
    }
}
-(NSArray *) sortedPhotosByPopularity
{
    NSArray *sortedArray=[self.photos sortedArrayUsingSelector:@selector(photoCompare:)];
    if ([sortedArray count]>LIMITPHOTOS) {
        NSArray *limitedArray=[sortedArray subarrayWithRange:NSMakeRange(0, LIMITPHOTOS)];
        for(Photo *photo in limitedArray)
        {
            NSLog(@"LIKESL:%@ URL:%@",photo.likes,photo.imageURL);
        }
        return limitedArray;
    }else{
        return sortedArray;
    }
}
-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"PushToCollection"]) {
        if ([self.photos count]&&[self.nickname.text isEqualToString:self.name]) {
            return YES;
        }else return NO;
    }
    return YES;
}

-(void) cancelWithAlert:(NSInteger) alertCode
{
    [self.spinner stopAnimating];
    self.spinner.hidden=YES;
    UIAlertView *alert;
    switch (alertCode) {
        case 1:
            alert=[[UIAlertView alloc]initWithTitle:@"Нет соединения" message:@"Не удалось подключиться к Instagram. Проверьте интернет соединение." delegate:self cancelButtonTitle:@"ОК" otherButtonTitles: nil];
            break;
        case 2:
            alert=[[UIAlertView alloc]initWithTitle:@"Нет такого ника" message:@"Не удалось найти пользователя с таким ником. Попробуйте еще раз." delegate:self cancelButtonTitle:@"ОК" otherButtonTitles: nil];
            self.nickname.text=@"";
            break;
        case 3:
            alert=[[UIAlertView alloc]initWithTitle:@"Пусто" message:@"К сожалению, у пользователя нет доступных фотографий." delegate:self cancelButtonTitle:@"ОК" otherButtonTitles: nil];
            break;
        case 4:
            alert=[[UIAlertView alloc]initWithTitle:@"Необходим ник" message:@"Пожалуйста, введите имя пользователя." delegate:self cancelButtonTitle:@"ОК" otherButtonTitles: nil];
            break;
        default:
            alert=[[UIAlertView alloc]initWithTitle:@"Ошибка" message:@"Неожиданно возникла ошибка(" delegate:self cancelButtonTitle:@"ОК" otherButtonTitles: nil];
            break;
    }
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

/////////////////////////////////////////////////////
#pragma mark - Downloading


- (void) fetchUser
{
    
    self.spinner.hidden=NO;
    [self.spinner startAnimating];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%@%@%@%s", APIINSTAGRAM,@"search?q=",self.nickname.text,@"&count=1&client_id=",CLIENTID]]];
    NSLog(@"%@",[NSString stringWithFormat:@"%s%@%@%@%s", APIINSTAGRAM,@"search?q=",self.nickname.text,@"&count=1&client_id=",CLIENTID]);
    NSURLSessionConfiguration *configuration=[NSURLSessionConfiguration ephemeralSessionConfiguration];
    configuration.timeoutIntervalForRequest=5.0;
    configuration.timeoutIntervalForResource=10.0;
    NSURLSession *session=[NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task=[session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        //NSLog(@"%@",location);
        [self loadUserInfoFromLocalURL:location andThenExecuteBlock:nil];
    }];
    [task resume];
    
}

- (void) fetchPhotosByUserID:(NSString *)userID
{
    
    self.spinner.hidden=NO;
    [self.spinner startAnimating];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%@%@%s", APIINSTAGRAM,userID,@"/media/recent?count=50&client_id=",CLIENTID]]];
    NSLog(@"%@",[NSString stringWithFormat:@"%s%@%@%s", APIINSTAGRAM,userID,@"/media/recent?count=50&client_id=",CLIENTID]);
    NSURLSessionConfiguration *configuration=[NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task=[session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        //NSLog(@"%@",location);
        [self loadPhotosInfoFromLocalURL:location andThenExecuteBlock:nil];
    }];
    [task resume];
    
}


- (NSDictionary *)dictionaryFromURL:(NSURL *)url
{
    NSDictionary *fullData;
    NSData *downloadedData = [NSData dataWithContentsOfURL:url];
    
    if (downloadedData) {
        fullData = [NSJSONSerialization JSONObjectWithData:downloadedData
                                                   options:0 error:NULL];
        return fullData;
    }else return nil;
}


- (void)loadUserInfoFromLocalURL:(NSURL *)localFile
           andThenExecuteBlock:(void(^)())blockExe
{
    NSDictionary *dictonaryOfUserInfo = [self dictionaryFromURL:localFile];
    //NSLog(@"%@",dictonaryOfUserInfo);
    NSArray *array=[dictonaryOfUserInfo valueForKeyPath:@"data.id"];
    //NSLog(@"%@",array);
    NSString *nickID=@"";
    if ([array count]) {
        if ([[array objectAtIndex:0] isKindOfClass:[NSString class]]) {
            nickID=[NSString stringWithFormat:@"%@",[array objectAtIndex:0]];
            //NSLog(@"%@",nickID);
        }
    }
    
    if ([nickID length]) { //User is founded
        [self fetchPhotosByUserID:nickID];
    }else{
        //alert
        dispatch_async(dispatch_get_main_queue(), ^{
            [self cancelWithAlert:2];
        });
        
        
    }
 
    
    //[self performSelectorOnMainThread:@selector(updateUIAfterFetch) withObject:nil waitUntilDone:NO];
    
    
    if (blockExe) blockExe();
}

- (void)loadPhotosInfoFromLocalURL:(NSURL *)localFile
             andThenExecuteBlock:(void(^)())blockExe
{
    NSDictionary *dictonaryOfPhotoInfo = [self dictionaryFromURL:localFile];
    //NSLog(@"%@",dictonaryOfPhotoInfo);
    NSArray *array=[dictonaryOfPhotoInfo valueForKeyPath:@"data"];
    if ([array count]){ //Photos founded
        for (NSDictionary *photoDict in array) {
            Photo *photo=[[Photo alloc]init];
            
            id likes=[photoDict valueForKeyPath:@"likes.count"];
            //NSLog(@"%@",likes);
            id url=[photoDict valueForKeyPath:@"images.thumbnail.url"];
            if (url) {
                photo.likes=[NSNumber numberWithInt:[likes intValue]];
                NSLog(@"LIKES: %@",photo.likes);
                NSString *string=[NSString stringWithFormat:@"%@",url];
                NSString *imageName=[string lastPathComponent];
                //NSLog(@"%@",imageName);
                photo.imageURL=[NSString stringWithFormat:@"%s%@",WEBIMAGE,imageName];
                
                [self.photos addObject:photo];
            }
            
            
            
        };
        
        if ([self.photos count]) {
            
             [self performSelectorOnMainThread:@selector(readyForSeque) withObject:nil waitUntilDone:NO];
            
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self cancelWithAlert:3];
        });
    }

    if (blockExe) blockExe();
}

-(void) readyForSeque
{
    [self.spinner stopAnimating];
    self.spinner.hidden=YES;
    self.name=[NSString stringWithString:self.nickname.text];
    [self performSegueWithIdentifier:@"PushToCollection" sender:self];
}


#pragma mark - NSURLSessionDownloadDelegate

// required by the protocol
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)localFile
{
}


- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
}


- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
