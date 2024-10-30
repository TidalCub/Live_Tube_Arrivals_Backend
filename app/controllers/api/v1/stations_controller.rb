class Api::V1::StationsController < ApplicationController
  before_action :validate_location, only: :LiveDeparturesPredictions

  def LiveDeparturesPredictions
    presenter = LiveDeparturesPredictionsPresenter.new(params[:lat], params[:lon])
    render json: presenter.as_json
  end

  private

  def validate_location
    return if params[:lat].present? && params[:lon].present?

    render json: { error: "Invalid latitute and longitude" }, status: :unprocessable_entity
  end
end
