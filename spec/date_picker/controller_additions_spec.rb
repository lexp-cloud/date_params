require 'spec_helper'

describe DateParams::ControllerAdditions do
  let(:mock_controller) do
    Class.new do
      attr_accessor :params
      include DateParams::ControllerAdditions
    end.new
  end
  let(:custom_params) do
    {
        date: '08/10/2012',
        paginated_date: '2012-08-10',
        invalid_date: '000000',
        model: {
            date: '08/10/2012'
        }
    }
  end
  let(:date) { Date.parse '2012-08-10' }

  context 'invalid format' do
    let(:param_spec) { :invalid_date }
    it 'should raise when unknown format' do
      mock_controller.params = custom_params
      expect { mock_controller.parse_date_param!(param_spec, {}) }.to raise_error ArgumentError, 'invalid date'
    end
  end

  context 'valid format' do
    before do
      mock_controller.params = custom_params
      mock_controller.parse_date_param!(param_spec, {})
    end

    context 'should update params' do
      let(:param_spec) { :date }
      subject { mock_controller.params[:date] }
      it { should eq date }
    end

    context 'should update nested params' do
      let(:param_spec) { [:model, :date] }
      subject { mock_controller.params[:model][:date] }
      it { should eq date }

      it 'should not change the original' do
        param_spec.should == [:model, :date]
      end
    end

    context 'when date format is yyyy-mm-dd from pagination' do
      let(:param_spec) { :paginated_date }
      subject { mock_controller.params[:paginated_date] }
      it { should eq date }
    end
  end
end
