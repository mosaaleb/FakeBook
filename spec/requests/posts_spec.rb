# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:post1) { create :post }
  let(:post2) { create :post }

  describe 'GET /:username/:posts_id' do
    it 'returns success' do
      get "/#{post1.user.username}/#{post1.id}"

      expect(response).to have_http_status(:ok)
    end

    it 'includes post_content in the body' do
      get "/#{post1.user.username}/#{post1.id}"

      expect(response.body).to include('he first post of this website')
    end
  end

  describe 'GET /posts/:post_id/edit' do
    context 'when not logged in' do
      it 'redirects to sign_in page' do
        get "/posts/#{post1.id}/edit"

        expect(response).to redirect_to('/accounts/sign_in')
      end
    end

    context 'when logged in' do
      before do
        sign_in post1.user
      end

      it 'is not expected to access another user edit post page' do
        get "/posts/#{post2.id}/edit",
            headers: { 'HTTP_REFERER' => "http://www.example.com/#{post2.user.username}/#{post2.id}" }

        expect(response).to redirect_to("/#{post2.user.username}/#{post2.id}")
      end

      it 'returns success' do
        get "/posts/#{post1.id}/edit"

        expect(response).to have_http_status :ok
      end
    end
  end

  describe 'POST /posts' do
    context 'when logged in and parameters are valid' do
      before do
        sign_in post1.user
        post_params = { post: post1.attributes, format: :js }
        post '/posts', params: post_params
      end

      it 'have ok http status' do
        expect(response).to have_http_status(:ok)
      end

      it 'contains the new published post' do
        expect(response.body).to include(post1.post_content)
      end
    end

    context 'when logged in and parameters are invalid' do
      it 'renders same page with error messages' do
        sign_in post2.user
        params = { post: post2.attributes, format: :js }
        post '/posts', params: params

        expect(flash[:alert]).to include("Post content can't be blank")
      end
    end
  end

  describe 'PUT /posts/:id' do
    context 'when not logged in' do
      it 'redirects to sign_in page' do
        put "/posts/#{post1.id}"

        expect(response).to redirect_to('/accounts/sign_in')
      end
    end

    context 'when logged in' do
      before do
        sign_in post1.user
      end

      it 'returns success' do
        post_params = { post: { post_content: 'I am the updated version' } }

        put "/posts/#{post1.id}", params: post_params

        expect(post1.reload.post_content).to include('I am the updated version')
        expect(response).to redirect_to("/#{post1.user.username}/#{post1.id}")
        expect(flash[:notice]).to include('Post successfully updated!')
      end
    end
  end

  describe 'DELETE /posts/:id' do
    context 'when not logged in' do
      it 'redirects to the sign_in page' do
        delete "/posts/#{post1.id}"

        expect(response).to redirect_to('/accounts/sign_in')
      end
    end

    context 'when logged in' do
      before do
        sign_in post1.user
      end

      it 'redirects to the other user post page' do
        delete "/posts/#{post2.id}", headers: { 'HTTP_REFERER' => "http://www.example.com/#{post2.user.username}/#{post2.id}" }

        expect(response).to redirect_to("/#{post2.user.username}/#{post2.id}")
      end

      it 'deletes the post' do
        delete "/posts/#{post1.id}"

        expect(Post.count).to be 0
        expect(response).to redirect_to('/')
      end
    end
  end
end
