# **Introduction**

This document goes through designing of a hybrid social media application, that has characteristics of both twitter and reddit.

The goal of this project is to build an application that provides services of different social media platforms as a whole.

**Background**

Twitter is a social networking site that allows users to share, post, like  and reply to short messages or ‘tweets’ with their followers. Tweets can include text, photos, videos, links, polls, and animated GIFs. For this project only text and photos are taken into consideration. Reddit is an online forum where users share news stories and other content.  One of the key characteristics of reddit is that users can create online communities and that’s part this project encompasses.

**Requirements**

* Only signed in Users can upload tweets containing images/text.  
* Users can react to other users’ tweets.  
* Tweets will be categorized into multiple categories by the uploading user.

# 

# **High Level Design**

![alt text](https://github.com/tsartrooper/chirp_nest/blob/main/images/social_app_architecture.png?raw=true)

**Image Storage(Cloud Storage)**

Images will be stored in cloud storage. This is scalable and cost effective for storing and serving images.

**Metadata/text content (Firestore)**

Image urls and text content of tweets (such as creation time, likes count, user name etc.) as well as user metadata will be stored in firestore.

**Authentication(Firebase Auth)**

Users can sign up using their email account.

**References**

Firebase Auth: [https://firebase.google.com/docs/auth](https://firebase.google.com/docs/auth)

Firestore: [https://firebase.google.com/docs/firestore](https://firebase.google.com/docs/firestore)

Firebase Storage: [https://firebase.google.com/docs/storage](https://firebase.google.com/docs/storage)

[image1]: <data:image/png;base64,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>
