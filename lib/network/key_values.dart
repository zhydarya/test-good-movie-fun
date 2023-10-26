class Query {
  Query._internal();

  static const authority = 'api.themoviedb.org';
  static const apiKey = 'api_key';
  static const apiKeyVal = '595b895b2fa36be92fad0eb4e2315201';
  static const pageKey = 'page';
  static const voteKey = 'vote_average.gte';
  static const yearKey = 'primary_release_year';
  static const castKey = 'with_people';
  static const videoKey = 'include_video';
  static const sortByKey = 'sort_by';
  static const sortByPopularity = 'popularity.desc';
  static const sortByVote = 'vote_average.desc';
  static const sortByTitle = 'original_title.desc';
  static const sortByRelease = 'release_date.desc';
  static const imageUrl = 'http://image.tmdb.org/t/p/w185/';
}

class Response {
  Response._internal();

  static const resultsKey = 'results';
  static const totalPagesKey = 'total_pages';
  static const pageKey = 'page';
  static const genresKey = 'genres';
  static const castKey = 'cast';
  static const crewKey = 'crew';
  static const profilesKey = 'profiles';
}
