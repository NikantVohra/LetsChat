
[![Build Status](https://travis-ci.org/NikantVohra/LetsChat.svg)](https://travis-ci.org/NikantVohra/LetsChat)

LetsChat is an app written in Swift that solves the following problem statement.

# Problem Statement
* Input: a chat message (string)
* Output: JSON string describing the special contents of the message mentioned below


### Mentions
A way to mention a user. Always starts with an '@' and ends when hitting a non-word character.
[How do @mentions work? – Help Center](http://help.hipchat.com/knowledgebase/articles/64429-how-do-mentions-work-)

### Emoticons
Custom emoticons which are alphanumeric strings, no longer than 15 characters, contained in parenthesis.
[HipChat - Emoticons](https://www.hipchat.com/emoticons)

### Links
Any URLs contained in the message, along with the page's title


# Instructions for Testing the app
1. Open the LetsChat.xcodeproj in Xcode.
2. Run the app by pressing cmd+R or test the various scenarios by pressing cmd+U.
3. Input your message.Press submit and see the output containing the required json string.
