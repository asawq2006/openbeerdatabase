class Api::V1::BeersController < Api::V1::BaseController
  before_filter :authenticate, :only => [:create]

  def index
    beers = Beer.search(params)

    render :json => {
      :page  => beers.current_page,
      :beers => beers
    }
  end

  def create
    beer = Beer.new(params[:beer])
    beer.user = current_user

    if beer.save
      head :created
    else
      head :bad_request
    end
  end

  def destroy
    beer = Beer.find(params[:id])

    if beer.user == current_user
      beer.destroy

      head :ok
    else
      head :unauthorized
    end
  end
end