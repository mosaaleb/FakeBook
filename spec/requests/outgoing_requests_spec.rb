# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OutgoingRequests', type: :request do
  let(:request1) { create :request }

  describe 'POST relationships/:id/:send_request' do
    context 'when not logged in' do
      it 'redirects to sign_in page' do
        post "/relationships/#{request1.receiver.id}/send_request"

        expect(response).to redirect_to('/accounts/sign_in')
      end
    end

    context 'when logged in' do
      it 'redirects back to same page' do
        sign_in request1.sender
        post "/relationships/#{request1.receiver.id}/send_request"

        expect(response).to redirect_to('/')
      end
    end
  end

  describe 'DELETE relationships/:id/remove_request' do
    context 'when not logged in' do
      it 'redirects to sign_in page' do
        delete "/relationships/#{request1.receiver.id}/remove_request"

        expect(response).to redirect_to('/accounts/sign_in')
      end
    end

    context 'when logged in' do
      it 'redirects back to same page' do
        sign_in request1.sender
        delete "/relationships/#{request1.receiver.id}/remove_request"

        expect(response).to redirect_to('/')
      end
    end
  end

  describe 'GET relationships/:id/sent_requests' do
    context 'when not logged in' do
      it 'redirects to sign_in page' do
        get '/sent_requests'

        expect(response).to redirect_to('/accounts/sign_in')
      end
    end

    context 'when logged in' do
      it 'has http sucess status' do
        sign_in request1.sender
        get '/sent_requests'

        expect(response).to have_http_status :ok
      end

    end
  end
end
