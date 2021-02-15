# frozen_string_literal: true

class GlossariesController < ApplicationController
  def create
    service = Glossaries::Create.call(
      source_language_code: params[:source_language_code],
      target_language_code: params[:target_language_code]
    )

    if service.success?
      render json: GlossaryRepresenter.new(service.result)
    else
      render json: { errors: service.errors }, status: 422
    end
  end
end
