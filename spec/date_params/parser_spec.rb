require 'spec_helper'

describe DateParams::Parser do
  let(:options) { {} }
  let(:parser) { described_class.new param, options, params }

  describe '#parse_date_param!' do
    let(:params) do
      {
          date: '08/10/2012',
          paginated_date: '2012-08-10',
          invalid_date: '000000',
          user: {
              notified_on: '08/10/2012'
          }
      }
    end
    let(:date) { Date.parse '2012-08-10' }

    context 'invalid format' do
      let(:param) { :invalid_date }
      it 'should raise when unknown format' do
        expect { expect parser.parse_date_param! }.to raise_error ArgumentError
      end
    end

    context 'valid format' do
      before { parser.parse_date_param! }

      describe 'param field is updated' do
        let(:param) { :date }
        subject { params[:date] }
        it { should eq date }
      end

      context 'namespace option is present' do
        let(:param) { :notified_on }
        let(:options) { { namespace: :user } }
        subject { params[:user][:notified_on] }
        it { should eq date }
      end

      context 'date format is yyyy-mm-dd from pagination' do
        let(:param) { :paginated_date }
        subject { params[:paginated_date] }
        it { should eq date }
      end
    end
  end

  describe '#parse_datetime_param!' do
    before { Time.zone = 'EST' }
    let(:params) do
      {
          created_on: '08/10/2012',
          created_time: '12:30 am',
          invalid_time: '1111',
          empty_time: '',
          user: {
              notified_on: '08/10/2012',
              notified_time: '12:30 am'
          }
      }
    end
    let(:datetime) { Time.zone.parse '2012-08-10 00:30' }

    context 'invalid format' do
      let(:param) { { date: :created_on, time: :invalid_time, field: :invalid_time } }
      it 'should raise when unknown format' do
        expect { expect parser.parse_datetime_param! }.to raise_error ArgumentError
      end
    end

    context 'valid format' do
      before { parser.parse_datetime_param! }

      describe 'param field is updated' do
        let(:param) { :created_at }
        subject { params[:created_at] }
        it { should eq datetime }
      end

      context 'namespace option is present' do
        let(:param) { :notified_at }
        let(:options) { { namespace: :user } }
        subject { params[:user][:notified_at] }
        it { should eq datetime }
      end

      context 'time is empty' do
        let(:param) { { date: :created_on, time: :empty_time, field: :created_at } }
        it 'parses the date but not the time' do
          params[:created_on].should eq datetime.to_date
          params[:created_at].should be_nil
        end
      end
    end
  end
end
