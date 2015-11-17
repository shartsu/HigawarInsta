#HigawarInsta

**HigawarInsta** is a Sinatra based web app shows one of your **"lovely"** instagram pics every day. 
Pics are picked randomly up from your associated account via **the instagram API**, so it's like **"日替わり" (HIGAWARI)** in Japanese. 

![ScreenShot](https://raw.githubusercontent.com/shartsu/HigawarInsta/ff07f0331f0b2685d82519b448d276f2ac005051/SC.png)

Hope you enjoy HIGAWARI instalife :)

### Developed environment
This app has been developed using Cloud9 service.
https://c9.io/
Using the web IDE service would be one of the easiest way to keep the app working. As for detail of Cloud9, please google it!

### Instagram API
This app needs you to register the instagram developer account on your own. 
https://instagram.com/developer/
Since they would request your app url and callback url, so you have to get them in order to register in advance. 

### Environment variable

Then, you will get your **CLIENT ID** and  **CLIENT SECRET** from your instagram developer tools.  Their values must be registered your environment via using a console or something and, at the same time, are important for activating your instagram APIs. 

``` python
export YOUR_CLIENT_ID="xxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
export YOUR_CLIENT_SECRET="yyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
```
For more details, please refer to following url.
https://instagram.com/developer/authentication/
