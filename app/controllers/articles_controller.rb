class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  def index
    @articles = Article.where(user_id: current_user.id)
  end
  

  def new
    @article = Article.new
    @article.images.new
    @draft = Draft.new
    @draft.images.new
    $draft = false
    $blob = []
  end

  def create
    if $draft
      targetModel = {main: Draft,   tag: Dtag, inter: TagDraft,   column: {main: "draft_id",   tag: "dtag_id"}, redirect: drafts_path}
    else
      targetModel = {main: Article, tag: Tag,  inter: TagArticle, column: {main: "article_id", tag: "tag_id"},  redirect: root_path}
    end
    @article = targetModel[:main].new(article_params)
    if @article.valid?
      @article.save
      if $blob != []
        @article.images.each.with_index do |a,i|
          @article.body.gsub!($blob[i],"https://s3-ap-northeast-1.amazonaws.com/numa-blog-app/uploads/image/image/#{a.id}/#{@article.images[i].image.filename}")
          @article.save
        end
      end
      params[:article][:tag].split(" ").each do |p|
        unless targetModel[:tag].find_by(name: p).present?
          targetModel[:tag].create(name: p)
        end
        targetModel[:inter].create(targetModel[:column][:tag] => targetModel[:tag].find_by(name: p).id, targetModel[:column][:main] => @article.id)
      end
      redirect_to targetModel[:redirect]
    else
      render :new
    end
  end

  def edit
    $blob = []
    if @article.images.exists?
      @article.images.each.with_index do |a,i|
        $blob << "https://s3-ap-northeast-1.amazonaws.com/numa-blog-app/#{a.image.path}/#{@article.images[i].image.filename}"
      end
    end
    tags = []
    TagArticle.where(article_id: @article.id).each do |t|
      tags << Tag.find(t.tag_id).name
    end
    @tag = tags.join(" ")
  end

  def update
    TagArticle.where(article: @article.id).destroy_all
    if @article.valid?
      @article.update(article_params)
      if $blob != []
        @article.images.each.with_index do |a,i|
          @article.body.gsub!($blob[i],"https://s3-ap-northeast-1.amazonaws.com/numa-blog-app/uploads/image/image/#{a.id}/#{@article.images[i].image.filename}")
          @article.save
        end
      end
      params[:article][:tag].split(" ").each do |p|
        unless Tag.find_by(name: p).present?
          Tag.create(name: p)
        end
        TagArticle.create(tag_id: Tag.find_by(name: p).id, article_id: @article.id)
      end
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    if @article.user_id == current_user.id
      if @article.destroy
        redirect_to root_path
      end
    end
  end

  def markdown
    @body = params[:body]
  end

  def set_blob
    $blob << params[:blob]
  end

  def search
    return nil if params[:search] == ""
    @articles = Article.where(["title LIKE ? OR body LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%"])
  end

  def set_draft
    $draft = true
  end

  private
  def article_params
    params[:article].permit(:title, :thumbnail, :abstract, :body, images_attributes: [:image, :_destroy, :id]).merge(user_id: current_user.id)
  end

  def set_article
    @article = Article.find(params[:id])
  end
end
