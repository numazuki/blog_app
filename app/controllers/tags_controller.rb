class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
    @articles = TagArticle.where(tag: params[:id])     
  end

end
