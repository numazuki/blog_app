class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]

  def new
    @article = Article.new
    @image = @article.images.new
    @@blob = []
  end

  def create
    @article = Article.new(article_params)
    if @article.save!
      @article.save
      if @@blob != []
        @article.images.each.with_index do |a,i|
          @article.body.gsub!(@@blob[i],"https://s3-ap-northeast-1.amazonaws.com/numa-blog-app/uploads/image/image/#{a.id}/#{@article.images[i].image.filename}")
          @article.save
        end
      end
      redirect_to root_path
    else
      render :new
    end
  end
  
  def markdown
    @body = params[:body]
  end

  def set_blob
    @@blob << params[:blob]
  end 


  
  private
  def article_params 
    params[:article].permit(:title,:thumbnail, :abstract, :body,images_attributes: [:image, :_destroy, :id, :article_id]).merge(user_id: current_user.id)
  end

  def set_article
    @article = Article.find(params[:id])
  end




  
  
end
