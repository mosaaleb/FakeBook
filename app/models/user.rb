# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook]

  # Validations
  validates :username, presence: true, uniqueness: true

  # Associations
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile

  has_many :outgoing_requests,
           foreign_key: 'sender_id',
           dependent: :destroy, class_name: 'Request'

  has_many :outgoing_pending_friends,
           through: :outgoing_requests, source: :receiver

  has_many :incoming_requests,
           foreign_key: 'receiver_id',
           dependent: :destroy, class_name: 'Request'

  has_many :incoming_pending_friends,
           through: :incoming_requests, source: :sender

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  has_many :inverse_friendships,
           class_name: 'Friendship',
           foreign_key: 'friend_id', dependent: :destroy

  has_many :inverse_friends, through: :inverse_friendships, source: :user

  has_many :posts, dependent: :destroy

  has_many :comments, dependent: :destroy
  has_many :commented_posts,
           through: :comments, dependent: :destroy, source: :post

  has_many :likes, dependent: :destroy
  has_many :liked_comments,
           through: :likes, source: :likable, source_type: 'Comment'
  has_many :liked_posts,
           through: :likes, source: :likable, source_type: 'Post'

  has_many :notifications, foreign_key: :recipient_id

  # Delegations
  delegate :first_name,
           :last_name,
           :gender,
           :date_of_birth,
           :about_me,
           :fullname,
           :image_path, to: :profile

  # Class methods
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.password = Devise.friendly_token[0, 20]
      user.email = auth.info.email
      user.username = auth.info.name.titlecase.split.join

      user.build_profile(
        first_name: auth.info.name.split(' ')[0],
        last_name: auth.info.name.split(' ')[1],
        image_path: auth.info.image
      )
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if (data = session['devise.facebook_data']) &&
         (session['devise.facebook_data']['extra']['raw_info'])
        user.email = data['email'] if user.email.blank?
      end
    end
  end

  def self.all_except(user)
    where.not(id: user)
  end

  # Instance methods
  def like(likable)
    likable.is_a?(Comment) ? liked_comments << likable : liked_posts << likable
  end

  def dislike(likable)
    if likable.is_a?(Comment)
      liked_comments.destroy(likable)
    else
      liked_posts.destroy(likable)
    end
  end

  def liked?(likable)
    if likable.is_a?(Comment)
      liked_comment_ids.include?(likable.id)
    elsif likable.is_a?(Post)
      liked_post_ids.include?(likable.id)
    end
  end

  def adds_comment(comment)
    comments << comment
  end

  def sends_request(receiver)
    outgoing_requests.create receiver: receiver
  end

  def unsend_request(request)
    outgoing_requests.destroy request
  end

  def already_sent_request?(user)
    outgoing_pending_friends.include?(user)
  end

  def rejects_request(request)
    incoming_requests.destroy request
  end

  def already_friends?(friend)
    all_friends.include?(friend)
  end

  def accepts_friendship(friend)
    friends << friend
    remove_request_upon_friendship_created(friend)
  end

  def deletes_friendship(friend)
    friends.destroy(friend)
    inverse_friends.destroy(friend)
  end

  def all_friends
    friends + inverse_friends
  end

  def to_param
    username
  end

  def timeline_posts
    Post.where(user_id: friend_ids + inverse_friend_ids + [id])
  end

  private

  def remove_request_upon_friendship_created(friend)
    request = incoming_requests.find_by(sender_id: friend.id)
    request.destroy
  end
end
