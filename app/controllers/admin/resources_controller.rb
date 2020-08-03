class Admin::ResourcesController < ApplicationController
  def create
    if params[:file]
      resource = Resource.new(resource:params[:file])
    else
      resource = Resource.new(resource:params[:img])
    end
    resource.save
    param = {
        resource:Rails.configuration.serverurl + resource.resource.url
    }
    param = {
        status:'ok',
        errno: 0,
        data: [
            Rails.configuration.serverurl + resource.resource.url
        ]
    }
    render json: param.to_json,content_type: "application/javascript"
  end
end
