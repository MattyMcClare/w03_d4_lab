require_relative('../db/sql_runner.rb')
require_relative('./casting.rb')
require_relative('./movie.rb')

class Performer
  attr_reader :id
  attr_accessor :first_name, :last_name
  def initialize(options)
    @id = options['id'].to_i if options['id']
    @first_name = options['first_name']
    @last_name = options['last_name']
  end

  def movies
    sql = 'SELECT movies.*
    FROM movies
    INNER JOIN castings
    ON castings.movie_id = movies.id
    WHERE performer_id = $1'
    values = [@id]
    movies = SqlRunner.run(sql, values)
    return Movie.map_items(movies)
  end

  def save
    sql = 'INSERT INTO performers (first_name, last_name)
    VALUES ($1, $2)
    RETURNING id'
    values = [@first_name, @last_name]
    performer = SqlRunner.run(sql, values).first
    @id = performer['id'].to_i
  end

  def update
    sql = 'UPDATE performers
    SET last_name = $1
    WHERE id = $2'
    values = [@last_name, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = 'DELETE FROM performers WHERE id = $1'
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all
      sql = 'SELECT * FROM performers'
      performers = SqlRunner.run(sql)
      return performers.map { |performer| Performer.new(performer) }
  end

  def self.delete_all
    sql = 'DELETE FROM performers'
    SqlRunner.run(sql)
  end

  def  self.map_items(performer_hash)
    return performer_hash.map { |performer| Performer.new(performer)  }
  end
end
