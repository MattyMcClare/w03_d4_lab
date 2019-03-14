require_relative('models/performer')
require_relative('models/movie')
require_relative('models/casting')

require('pry')

# Casting.delete_all
# Movie.delete_all
# Performer.delete_all

performer1 = Performer.new({
  'first_name' => 'Brad',
  'last_name' => 'Pitt'
  })
performer1.save

performer2 = Performer.new({
  'first_name' => 'Angelina',
  'last_name' => 'Pitt'
  })
performer2.save

movie1 = Movie.new({
  'title' => 'World War Z',
  'genre' => 'Drama/Horror/Sci-Fi',
  'budget' => '120'
  })
movie1.save

casting1 = Casting.new({
  'movie_id' => movie1.id,
  'performer_id' => performer1.id,
  'fee' => '45'
  })
casting1.save

casting2 = Casting.new({
  'movie_id' => movie1.id,
  'performer_id' => performer2.id,
  'fee' => '65'
  })
casting2.save

# p movie1.castings

# p Casting.all
# p Movie.all
# p Performer.all

# performer1.last_name = 'Pet'
# p performer1.update
#
# movie1.title = 'World War ABC'
# p movie1.update
#
# casting1.fee = '1000000'
# casting1.update
# p casting1.fee

# performer1.delete
# movie1.delete
# casting1.delete

# p Casting.all
# p Movie.all
# p Performer.all



binding.pry
nil
