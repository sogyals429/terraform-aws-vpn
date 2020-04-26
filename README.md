# OpenVpn Server 
Basic OpenVPN server using IAC(Terraform) & AWS. 
[https://github.com/sogyals429/terraform-aws-vpn/blob/master/LICENSE](https://github.com/sogyals429/terraform-aws-vpn/blob/master/LICENSE)
# Prerequisites

- Terraform 12 [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)
- AWS Account [https://aws.amazon.com/](https://aws.amazon.com/)
- AWS CLI [https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

## How to implement

1. Clone the repo
2. Make sure you have an AWS account and installed AWS CLI on your system. Follow this article for more info on how to create a credentials file for your AWS CLI [https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
3. Update public key in `04-instance.tf` `aws_key_pair` resource to use your own. Your Public key can be found via terminal using `cat ~/.ssh/key_name.pub`  command.
4. Open `variables.tfvars` and update the `my_ip` variable to use your own public IP address. To retrieve your public ip you can execute `curl ifconfig.co` via the terminal.
5. Once all of the variables are updated execute `make vpn` from the terminal and once terraform asks for an input enter `yes` to let terraform build your environment.
6. After your environment has been setup you can ssh into your **ec2-instance** using your private key`ssh -i ~/.ssh/private_key`.
7. Once you successfully are able to access your instance please follow this article by OpenVPN as to how you want to configure your OpenVPN server. [https://openvpn.net/vpn-server-resources/amazon-web-services-ec2-byol-appliance-quick-start-guide/](https://openvpn.net/vpn-server-resources/amazon-web-services-ec2-byol-appliance-quick-start-guide/). You can follow the steps of the OpenVPN server setup until your reach the `Changing_Default_Timezone` section as terraform does rest of the stuff. 
8. Once installed login with your local instance credentials username `openvpn` and to set the user password please execute `sudo passwd openvpn` to set a password for the user. After configuration is complete you can head over to `https://your_ip:943/?src=connect`to download your VPN profile for your system. 
9. To connect system to VPN you will need to download a VPN Client e.g. [Tunnelblick](https://tunnelblick.net/downloads.html) or OpenVPN Connect (can be found in the profile page) as seen below.
 ![OpenVPN Connect App](https://i.ibb.co/bXrMpYq/Screen-Shot-2020-04-26-at-11-07-59-am.png)

## Want to Help?
Feel free to make an PR's or raise any issues 😍
