# movies

With the project we've built in this chapter, you are now able to read data from an external source in any app that you'll design. This opens up literally endless opportunities for your creations.

In particular, we've seen how to leverage the get() method of the http library to retrieve data from a URL.

We've seen an example of JSON, used the decode method, and seen how to deal with an http.Response object.

We've checked the Response status with the HttpStatus enumerator and parsed some JSON content using the map() method.

We've dealt with a powerful tool in Dart and Flutter, which is asynchronous programming:
using the async, await, and then keywords, together with the Future object, we've created a set of functions and features that do not block the main execution thread of your
app.
Hopefully, you now understand how to leverage multi-threading in your Flutter apps.

We've also downloaded images from the web with Image.network() and NetworkImage.

For the UI, we've seen how to use a ListView using the builder constructor. By setting the itemCount and itemBuilder parameters, we created a nice, scrolling list in an efficient way. We've also added ListTile widgets, with their title, subtitle, and leading properties.

We've seen how easy it is to pass data through screens in Flutter by leveraging the MaterialPageRoute builder constructor and hence creating a second screen for the details of a Movie without having to download any data.

Finally, we've added a search feature to our app.
Using AppBar again, we've changed the widgets dynamically based on the user actions and performed a search over the Movie Database web service.

You've added a powerful tool to your Flutter toolkit: the ability to retrieve data from an outside service.
