require 'spec_helper'
require 'active_support'
require 'rollbar'

RSpec.describe Faraday::Sunset do

  let(:options) { {} }
  let(:app) { double(:app) }
  let(:response_headers) { {} }
  let(:response) { Faraday::Response.new(env) }

  let(:env) do
    Faraday::Env.from({
      url: 'http://example.com/foo', body: nil, request: {},
      request_headers: Faraday::Utils::Headers.new,
      response_headers: Faraday::Utils::Headers.new(response_headers)
    })
  end

  subject { described_class.new(app, options) }

  describe '#call' do

    before do
      allow(app).to receive(:call) { response }
    end

    context 'when no sunset header' do
      it 'calls app and calls on_complete' do
        response = Faraday::Response.new(env)
        expect(app).to receive(:call) { response }
        expect(response).to receive(:on_complete)
        subject.call(env)
      end

      it 'ActiveSupport::Deprecation.warn will not be called' do
        expect(ActiveSupport::Deprecation).not_to receive(:warn)
        subject.call(env)
      end
    end

    context 'when sunset header is set' do
      let(:sunset_date) { DateTime.new(2050,2,3,4,5,6,'+00:00') }

      let(:response_headers) { { sunset: sunset_date.httpdate } }

      let(:expected_sunset_message) { "Endpoint http://example.com/foo is deprecated for removal on #{sunset_date.iso8601}" }

      it 'raise NoOutputForWarning' do
        expect { subject.call(env) }.to raise_error(described_class::NoOutputForWarning)
      end

      context 'and active_support option is enabled' do
        let(:options) { { active_support: true } }

        it 'ActiveSupport::Deprecation.warn will be called' do
          expect(ActiveSupport::Deprecation).to receive(:warn).with(expected_sunset_message)
          subject.call(env)
        end
      end

      context 'and logger option is enabled' do
        let(:logger) { double('logger') }
        let(:options) { { logger: logger } }

        it 'ActiveSupport::Deprecation.warn will be called' do
          expect(logger).to receive(:warn).with(expected_sunset_message)
          subject.call(env)
        end
      end

      context 'and rollbar option is enabled' do
        context 'rollbar is "on"' do
          let(:options) { { rollbar: 'on' } }

          it 'calls rollbar when options[:rollbar] is "on"' do
            expect(Rollbar).to receive(:warning).with(expected_sunset_message)
            subject.call(env)
          end

          it 'throws an error when options[:rollbar] is "on" and rollbar is not present"' do
            allow(Rollbar).to receive(:warning) { raise StandardError.new }
            expect{ subject.call(env) }.to raise_error
          end
        end

        context 'rollbar is "auto"' do
          let(:options) { { rollbar: 'auto' } }
          it 'calls rollbar when options[:rollbar] is "auto"' do
            expect(Rollbar).to receive(:warning).with(expected_sunset_message)
            subject.call(env)
          end

          it 'throws an NoOutputForWarning when options[:rollbar] is "auto" and rollbar is not present' do
            allow(Rollbar).to receive(:warning) { raise StandardError.new }
            expect{ subject.call(env) }.to raise_error(Faraday::Sunset::NoOutputForWarning)
          end
        end

        context 'rollbar is "off" or not present' do
          let(:options) { { rollbar: 'off' } }
          it 'does not warn when options[:rollbar] is "off"' do
            expect{ subject.call(env) }.to raise_error(Faraday::Sunset::NoOutputForWarning)
          end

          it 'does not warn when options[:rollbar] is not present' do
            options = {}
            expect{ subject.call(env) }.to raise_error(Faraday::Sunset::NoOutputForWarning)
          end

          it 'does not throw an error when rollbar is missing and options[:rollbar] is "off"' do
            allow(Rollbar).to receive(:warning) { raise StandardError.new }
            expect{ subject.call(env) }.to raise_error(Faraday::Sunset::NoOutputForWarning)
          end
        end

      end
    end
  end
end
