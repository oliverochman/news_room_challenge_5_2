class ArticlesController < ApplicationController
  before_action :get_coordinates, only: [:index]

  def index
    @articles = Article.all
  end

  def new
    @article = Article.new
    authorize @article
  end

  def show
    @article = Article.find(params[:id])
  end

  def create
    article = Article.create(article_params)
    article.image.attach(params[:article][:image])
    redirect_to article
  end

  private

  def article_params
    params.require(:article).permit(:title, :body)
  end

  def set_edition
    if User.near([59.224443,18.198229], 100).include? current_user
      @edition = 'Stockholm Edition'
    else
      @edition = 'Rest of Sweden Edition'
    end
  end


  def get_coordinates
    @coordinates = {}
    if cookies['geocoderLocation'].present?
      @coordinates = JSON.parse(cookies['geocoderLocation']).to_hash.symbolize_keys
      set_edition
      @geocoded = true
    else
      @geocoded = false
    end
  end
end
