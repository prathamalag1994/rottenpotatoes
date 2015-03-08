class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort] || session[:sort] 
    @all_ratings = Movie.get_all_ratings
    x = false

    ratings = params[:ratings] || session[:ratings] || {}
    if ratings != {}
      @ratings = ratings
    else
      @ratings = Hash.new
      @all_ratings.each {|r| @ratings[r] = 1}
    end
    if params[:ratings]
      session[:ratings] = @ratings
    elsif session[:ratings]
      x = true
    end
    
    if params[:sort]
      session[:sort] = sort
    elsif session[:sort]
      x = true
    end

    if x
      redirect_to :sort => sort, :ratings => @ratings
    end

    if sort == "title"
      @movies = Movie.where(rating: @ratings.keys).order("title")
      @title = "hilite"
    elsif sort == "date"
      @movies = Movie.where(rating: @ratings.keys).order("release_date")
      @date = "hilite"
    else
      @movies = Movie.where(rating: @ratings.keys)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def samed
    
    if params[:director].nil? || params[:director].length == 0
      flash[:notice] = "'#{params[:title]}' has no director info"
      redirect_to movies_path
    end
    @movies = Movie.finddir(params[:director])
  end

end
