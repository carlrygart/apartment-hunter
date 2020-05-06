# apartment-hunter

apartment-hunter is an application that helps you to get notified when an apartment at bostad.stockholm.se is available. The application is easily deployed with AWS Lambda (for free) with an interval trigger.

### Notice
Note that in the currect state, the application is hardcoded to only look for appartments matching property `bostadssnabben`. However, this can easily be changed. The current check interval is 1 min.

### Prerequisites
* [AWS CLI](https://aws.amazon.com/cli/)
* [Terraform](https://www.terraform.io/downloads.html)

### Deploy your own apartment-hunter
1. Create a free account at [AWS](https://aws.amazon.com/)
1. Get your AWS secrets and login with AWS CLI
1. Create account at [Mailgun](https://mailgun.com/) and SMTP credentials
1. Set required Mailgun crentials in SSM in AWS
1. Setup your email and other preferences in `handler.js`
1. Install dependencies `yarn install`
1. Deploy to AWS with Terraform `yarn deploy`
1. Enjoy! 🎉
