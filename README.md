# Project 1 - Flick

Flick is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: 11 hours spent in total

## User Stories

The following **required** functionality is complete:

- [X] User can view a list of movies currently playing in theaters from The Movie Database.
- [X] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [X] User sees a loading state while waiting for the movies API.
- [X] User can pull to refresh the movie list.
- [X] User can view movie details by tapping on a cell.
- [X] User can select from a tab bar for either **Now Playing** or **Top Rated** movies.
- [ ] Customize the selection effect of the cell.
- 
The following **optional** features are implemented:

- [ ] User sees an error message when there's a networking error.
- [X] Movies are displayed using a CollectionView instead of a TableView.
- [ ] User can search for a movie.
- [X] All images fade in as they are loading.
- [ ] Customize the UI.
- [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [ ] Customize the navigation bar.

The following **additional** features are implemented:

- [X] A default image is put in place for movies that do not have posters yet.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. The best ways to debug
2. The syntax of importing data

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/lAIYmzH.gif' title='Flick Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

The initial creation of the app was not terribly difficult. However, the conversion from using a TableView to a 
CollectionView was quite the challenge. It involved modifying just certain pieces of code within just about every
segment of my app. However, after finally fixing my "black screen of death" I am proud to say that the app is operational!

## License

    Copyright 2016 Cole McLemore

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.04
