class Movie {
  late int id;
  late String title;
  late double voteAverage;
  late String releaseDate;
  late String overview;
  late String posterPath;

  Movie(
    this.id,
    this.title,
    this.voteAverage,
    this.releaseDate,
    this.overview,
    this.posterPath
  );

  /*
  This named constructor will return a Movie object.
  As a parameter, it will take a Map, which is a key-value pair set.
  The key will be a string (for example, "title"), and the value needs to be dynamic, as it can be text or a number.
  */
  Movie.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    title = parsedJson['title'];
    voteAverage = parsedJson['vote_average'] as double;
    releaseDate = parsedJson['release_date'];
    overview = parsedJson['overview'];
    posterPath = parsedJson['poster_path'];
  }
}