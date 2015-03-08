class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date, :director
  def self.get_all_ratings
  	Movie.select("DISTINCT rating").map(&:rating)
  end
  
  def self.finddir(string)
    Movie.where(["director = ?", string])
  end
end
