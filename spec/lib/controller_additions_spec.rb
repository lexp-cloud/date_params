require 'spec_helper'
describe DateParams::ControllerAdditions, type: :controller do
  render_views false

  controller do
    date_params :created_at_gteq, namespace: :q, only: [:index]
    datetime_params :sign_up_at, namespace: :q, only: [:index]

    def index
      @created_at_gteq = params[:q][:created_at_gteq]
      @sign_up_at = params[:q][:sign_up_at]
      render :json => {}
    end
  end

  let(:date_params) { { q: {created_at_gteq: '2010-05-01'} } }
  let(:datetime_params) { { q: { sign_up_at_date: '01/05/2013', sign_up_at_time: '7:30 pm'} } }

  it 'parses the created_at_gteq' do
    params = Rails::VERSION::MAJOR.to_i >= 5 ? { params: date_params } : date_params
    get :index, params
    expect(assigns[:created_at_gteq]).to be_instance_of(Date)
  end

  it 'parses the created_at_gteq' do
    params = Rails::VERSION::MAJOR.to_i >= 5 ? { params: datetime_params } : datetime_params
    get :index, params
    expect(assigns[:sign_up_at]).to be_instance_of(ActiveSupport::TimeWithZone)
  end
end