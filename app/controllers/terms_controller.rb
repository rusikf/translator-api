# frozen_string_literal: true

class TermsController < ApplicationController
  def create
    service = Terms::Create.call(
      source_term: params[:source_term],
      target_term: params[:target_term],
      glossary: glossary
    )

    if service.success?
      render json: representer.new(service.result)
    else
      render json: { errors: service.errors }, status: 422
    end
  end

  private

  def glossary
    @glossary = Glossary.find(params[:glossary_id])
  end

  def representer
    TermRepresenter
  end
end
