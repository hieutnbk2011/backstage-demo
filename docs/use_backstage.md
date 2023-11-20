
After deployment complete, the portal should be available at the address you define in variable file.

![backstage portal](https://raw.githubusercontent.com/hieutnbk2011/backstage-demo/main/docs/demo-instance.jpg)

Because we using a self-signed certificate and a non-existed domain, so we need to trust the certificate and also modify hosts file to show the portal on browser.

Get the alb dns name and its public ip
![alb public ip](https://raw.githubusercontent.com/hieutnbk2011/backstage-demo/main/docs/alb-public-ip.JPG)

Update the host file

![update host file](https://raw.githubusercontent.com/hieutnbk2011/backstage-demo/main/docs/update-hosts-file.JPG)
