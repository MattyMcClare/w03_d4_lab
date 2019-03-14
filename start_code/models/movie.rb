require_relative('../db/sql_runner.rb')
require_relative('./performer.rb')
require_relative('./casting.rb')

class Movie
  attr_reader :id
  attr_accessor :title, :genre, :budget
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @genre = options['genre']
    @budget = options['budget'].to_i
  end

  def remaining_budget
    total_fee = castings.reduce(0) { |sum, casting| sum += casting.fee }
    return @budget - total_fee
  end

  def performers
    sql = 'SELECT performers.*
    FROM performers
    INNER JOIN castings
    ON castings.performer_id = performers.id
    WHERE movie_id = $1'
    values = [@id]
    performers = SqlRunner.run(sql, values)
    return Performer.map_items(performers)
  end

  def castings
    sql = 'SELECT * FROM castings WHERE movie_id = $1'
    values = [@id]
    casting_hash = SqlRunner.run(sql, values)
    return casting_hash.map { |casting| Casting.new(casting) }
  end

  def save
    sql = 'INSERT INTO movies (title, genre)
    VALUES ($1, $2)
    RETURNING id'
    values = [@title, @genre]
    movie = SqlRunner.run(sql, values).first
    @id = movie['id'].to_i
  end

  def update
    sql = 'UPDATE movies
    SET title = $1
    WHERE id = $2'
    values = [@title, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = 'DELETE FROM movies WHERE id = $1'
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all
      sql = 'SELECT * FROM movies'
      movies = SqlRunner.run(sql)
      return movies.map { |movie| Movie.new(movie) }
  end

  def self.delete_all
    sql = 'DELETE FROM movies'
    SqlRunner.run(sql)
  end

  def  self.map_items(movie_hash)
    return movie_hash.map { |movie| Movie.new(movie)  }
  end
end
