# frozen_string_literal: true

class TranslationsController < ApplicationController
  def create
    service = Translations::Create.call(
      source_language_code: params[:source_language_code],
      target_language_code: params[:target_language_code],
      glossary_id: params[:glossary_id],
      source_text: params[:source_text]
    )

    if service.success?
      render json: representer.new(service.result)
    else
      render json: { errors: service.errors }, status: 422
    end
  end

  def show
    render json: representer.new(translation)
  end

  private

  def translation
    @translation = Translation.find(params[:id])
  end

  def representer
    TranslationRepresenter
  end
end
