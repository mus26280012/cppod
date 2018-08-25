
#import "ZJTUserHelpViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <MJExtension/MJExtension.h>
#import "ZJTGetModel.h"
#import "ZJTUserHelpView.h"
#import <AFNetworking/AFNetworking.h>
@interface ZJTUserHelpViewController ()<UIWebViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)ZJTUserHelpView *helpView;
@property(nonatomic,strong)NSString *urlString;
@property(nonatomic,strong)UIImageView *iv;
@end

@implementation ZJTUserHelpViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.iv = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.iv];
    self.iv.image = self.qidongImage;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initShare];
    
}

-(void)initShare {

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *str=   [NSString stringWithFormat:@"https://www.vr439.com/Api/act/get_api?app_id=%@",self.appid];
//#warning - 测试id=1425608954，测试完毕之后用自己的app_id
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html", nil];
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                 NSLog(@"下载的进度");
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     NSLog(@"请求成功:%@", responseObject);
                 self.iv.hidden = YES;
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 ZJTGetModel *model = [ZJTGetModel mj_objectWithKeyValues:responseObject];
                 model.code=200;
                 model.result.show_icon=1;
                 if (model.code==200&&model.result.show_icon==1) {
                     //二级保护，进入生产模式
                     self.urlString=model.result.iconimage;
                     [self initUI];
                 }else
                 {
                     id appd = [UIApplication sharedApplication].delegate;
                     UIWindow *window = [appd valueForKey:@"window"];
                     window.rootViewController = [appd valueForKey:@"vc"];
                 }
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"请求失败:%@", error);
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                     //网络错误
                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络错误" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                     [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                         [self initShare];
                     }]];
                     [self presentViewController:alert animated:YES completion:nil];
                     }];
    
//    [NetworkCenter requestWithType:kRequestTypeGet URL:str parameters:nil completion:^(BOOL isSuccess, NSDictionary *answer, NSString *errorMessage) {
//        [SVProgressHUD dismiss];
//        if (isSuccess==YES) {
//            ZJTGetModel *model = [ZJTGetModel mj_objectWithKeyValues:answer];
//            model.code=200;
//            model.result.show_icon=1;
//            if (model.code==200&&model.result.show_icon==1) {
//                //二级保护，进入生产模式
//                self.urlString=model.result.iconimage;
//                [self initUI];
//            }
//        }else {
//            //网络错误
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络错误" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
//                [self initShare];
//            }]];
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//        
//    }];
}

#pragma mark - 原有方法
-(void)initUI{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.helpView = [[[NSBundle  mainBundle]  loadNibNamed:@"ZJTUserHelpViewXib" owner:self options:nil]  lastObject];
    self.helpView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.helpView.webView.delegate=self;
    [self setNeedsStatusBarAppearanceUpdate];
    [self.view addSubview:self.helpView];
    self.view.hidden=NO;
    NSString *helpString=self.urlString;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:helpString]];
    [self.helpView.webView loadRequest:request];
    
    [self.helpView.button1 addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.helpView.button2 addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.helpView.button3 addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.helpView.button4 addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.helpView.button5 addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.helpView.againButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    self.helpView.againButton.tag=6;
    self.helpView.errorView.hidden=YES;
}

-(void)buttonPress :(UIButton*)sender {
    if (sender.tag==1) {//首页
        NSString *helpString=self.urlString;
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:helpString]];
        [self.helpView.webView loadRequest:request];
    }else if (sender.tag==2) {//
        if (self.helpView.webView.canGoBack) {
            [self.helpView.webView goBack];
        }
    }else if (sender.tag==3) {//
        if(self.helpView.webView.canGoForward) {
            [self.helpView.webView goForward];
        }
    }else if (sender.tag==4) {//shuaxin
        [self.helpView.webView reload];
    }else if (sender.tag==5) {//tuichu
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否要退出" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            NSArray *aa=[[NSArray alloc]init];
            NSLog(@"%@",aa[11]);
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if (sender.tag==6) {
        [self.helpView.webView reload];
    }
}

//更新 UI 布局
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

#pragma mark - ------ 网页代理方法 ------

//是否允许加载网页
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%@",request.URL.absoluteString);
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    self.helpView.errorView.hidden=YES;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error   {
    if (error.code==-1003) {
        
    }else {
        self.helpView.errorView.hidden=NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
}

@end


