class GlassesController < ApplicationController
    
    skip_before_action :verify_authenticity_token

    def index
        render json: Glass.all
    end

    def show
        render json: Glass.find(params["id"])
    end

    def create
        render json: Glass.create(params["glass"])
    end

    def delete
        render json: Glass.delete(params["id"])
    end

    def update
        render json: Glass.update(params["id"], params["glass"])
    end

end