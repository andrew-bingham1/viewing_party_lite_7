class Movie

  attr_reader :title, 
              :vote_average,
              :id,
              :runtime,
              :genres,
              :summary,
              :poster

  def initialize(data)
    @data = data
    @title = data[:title]
    @vote_average = data[:vote_average]
    @id = data[:id]
    @runtime = data[:runtime]
    @genres = data[:genres]
    @summary = data[:overview]
    @poster = data[:poster_path]
  end
end