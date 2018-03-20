class ArticlesController < ApplicationController
  before_action :authorize_user_as_author, only: [:new]
  def index
    @articles = Article.all
  end

  def new
    @article = Article.new
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
end
