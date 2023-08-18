class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @movies = Movie.all
      # filter title
      @movies = @movies.where('title LIKE ?', "#{params[:title]}%") if params[:title].present?
      # filter relase_year
      @movies = @movies.where('strftime("%Y", release_date) = ?', params[:release_year]) if params[:release_year].present?
      # filter rating
      @movies = @movies.where(rating: params[:rating]) if params[:rating].present?

      # sorting
      if params[:sort] == 'title'
        @movies = @movies.order(title: :asc)
      elsif params[:sort] == 'rating'
        @movies = @movies.order(rating: :desc)
      elsif params[:sort] == 'release_date'
        @movies = @movies.order(release_date: :desc)
      end
      
    end
  
    def new
      # default: render 'new' template
    end

    # def sort

    # end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end