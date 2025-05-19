# shopping

Storing data into a device is a key skill in Flutter development. 
In this chapter, we have created a data-driven app, leveraging the SQLite database.

In order to add the SQLite features in Flutter, we used the sqflite library, which contains asynchronous helper methods for SELECT, INSERT, UPDATE, and DELETE queries.

We used the openDb method, which returns a database object. 
The first time we called this method, the database was created with the specified name and version, and the following times, it was only opened.

We called the execute method to use the SQL language to insert records, and the rawQuery method to use a SELECT statement against the database.

We've created model classes that mirrored the structure of the tables in a database to make the code more reliable, easier to read, and to prevent data inconsistencies.

We used the insert, update, and delete helper methods specifying the where and whereArgs parameters, and used Map objects to deal with the data.

We've seen factory constructors, which allow you to override the default behavior whenever you call the constructor of a class.
Instead of creating a new instance, the factory constructor only returns an instance of the class, thus implementing the "singleton" pattern, which restricts the instantiation of a class to one "single" instance.

We've used the showDialog() method to build parts of the UI to interact with our user, and leveraged the Swipe action with the Dismissible objects to delete data.