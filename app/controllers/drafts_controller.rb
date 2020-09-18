class DraftsController < ApplicationController
  before_action :set_draft, only: [:show, :edit, :update, :destroy]

  def edit
    $draft = false
    $blob = []
    if @draft.images.exists?
      @draft.images.each.with_index do |a,i|
        $blob << "https://s3-ap-northeast-1.amazonaws.com/numa-blog-app/#{a.image.path}/#{@draft.images[i].image.filename}"
      end
    end
    tags = []
    TagDraft.where(draft_id: @draft.id).each do |t|
      tags << Dtag.find(t.dtag_id).name
    end
    @tag = tags.join(" ")
  end

  def update
    TagDraft.where(draft: @draft.id).destroy_all
    if $draft
      targetModel = {tag: Dtag, inter: TagDraft,   column: {main: "draft_id",   tag: "dtag_id"}, redirect: drafts_path}
      if @draft.valid?
        @draft.update(draft_params)
      else
        render :edit
      end
    else
      targetModel = {tag: Tag,  inter: TagArticle, column: {main: "article_id", tag: "tag_id"},  redirect: root_path}
      @draft = Article.new(draft_params)
      if @draft.valid?
        @draft.save
      else
        render :edit
      end
    end
    if $blob != []
      @draft.images.each.with_index do |a,i|
        @draft.body.gsub!($blob[i],"https://s3-ap-northeast-1.amazonaws.com/numa-blog-app/uploads/image/image/#{a.id}/#{@draft.images[i].image.filename}")
        @draft.save
      end
    end
    params[:draft][:tag].split(" ").each do |p|
      unless targetModel[:tag].find_by(name: p).present?
        targetModel[:tag].create(name: p)
      end
      targetModel[:inter].create(targetModel[:column][:tag] => targetModel[:tag].find_by(name: p).id, targetModel[:column][:main] => @draft.id)
    end
    unless $draft
      Draft.find(params[:id]).destroy
    end
    redirect_to targetModel[:redirect]
  end

  def destroy
    if @draft.user_id == current_user.id
      if @draft.destroy
        redirect_to root_path
      end
    end
  end

  private
  def draft_params
    
    params[:draft].permit(:title, :thumbnail, :abstract, :body, images_attributes: [:image, :_destroy, :id]).merge(user_id: current_user.id)

  end

  def set_draft
    @draft = Draft.find(params[:id])
  end
end
