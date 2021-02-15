# frozen_string_literal: true

class GlossariesController < ApplicationController
  def create
    service = Glossaries::Create.call(
      source_language_code: params[:source_language_code],
      target_language_code: params[:target_language_code]
    )

    if service.success?
      render json: representer.new(service.result)
    else
      render json: { errors: service.errors }, status: 422
    end
  end

  def index
    rel = Glossary.all
    render json: representer.for_collection.new(rel)
  end

  def show
    render json: representer.new(glossary)
  end

  private

  def glossary
    @glossary = Glossary.find(params[:id])
  end

  def representer
    GlossaryRepresenter
  end
end
