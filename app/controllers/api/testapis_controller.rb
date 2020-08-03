class Api::TestapisController < ApplicationController
  def index
    logger.info "============================================================="
    return_api('')
  end
end
