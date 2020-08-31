class ArticlesController < ApplicationController
  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.valid?
      @article.save
      redirect_to root_path
    else
      render :new
    end
    
  end

  private
  def article_params 
    params[:article].permit(:title, :thumbnail, :abstract, :body).merge(user_id: current_user.id)
  end
  
end
