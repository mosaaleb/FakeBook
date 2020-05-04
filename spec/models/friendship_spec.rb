# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:friendship) { create :friendship }
  let(:user) { create :user }
  let(:user2) { create :user }
  let(:friend) { create :user }

  describe 'DB validations' do
    context 'when friendship already exists' do
      it 'is invalid' do
        user.friendships.create friend: friend

        friendship = user.friendships.build friend: friend
        expect { friendship.save validate: false }
          .to raise_error(ActiveRecord::RecordNotUnique)

        inverse_friendship = friend.friendships.build friend: user
        expect { inverse_friendship.save validate: false }
          .to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe 'Validation' do
    context 'when friendship already exists' do
      it 'is invalid' do
        user.friendships.create friend: friend

        friendship = user.friendships.create friend: friend
        expect(friendship.errors[:user_id]).to include('already friends')

        inverse_friendship = friend.friendships.create friend: user
        expect(inverse_friendship.errors[:user_id])
          .to include('already friends')
      end
    end
  end

  context 'when user creates friendship relation with himself' do
    it 'is invalid' do
      friendship = user.friendships.create friend: user

      expect(friendship.errors[:user_id]).to include(/can't friend yourself/)
    end
  end

  describe 'Associations' do
    context 'when called upon inverse_relationships' do
      it 'returns all inverse_friendships' do
        user.friendships.create friend: friend
        expect(user.friendships.first.id)
          .to eq(friend.inverse_friendships.first.id)
      end
    end

    context 'when called on friends' do
      it 'returns all friends' do
        user.friendships.create friend: friend
        expect(user.friends.first.id).to eq(friend.id)
      end
    end

    context 'when called on inverse_friends' do
      it 'returns all friends' do
        user.friendships.create friend: friend
        expect(friend.inverse_friends.first.id).to eq(user.id)
      end
    end

    context 'when user calls all_friends' do
      it 'returns friends and inverse_friends' do
        user.friendships.create friend: friend
        friend.friendships.create friend: user2

        expect(friend.all_friends).to include(user && user2)
      end
    end

    context 'when user is destroyed' do
      it 'is expected to destroy dependent friendships' do
        friendship
        expect { friendship.user.destroy }
          .to change(described_class, :count).by(-1)
      end
    end
  end
end
