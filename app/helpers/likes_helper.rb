# frozen_string_literal: true

module LikesHelper
  def like_button(likable)
    if current_user.liked?(likable)
      link_to fa_icon('heart', class: 'text-danger'),
              polymorphic_path([:dislike, likable], type: likable.class),
              method: :delete, remote: not_guest?
    else
      link_to fa_icon('heart', class: 'text-light stroke'),
              polymorphic_path([:like, likable], type: likable.class),
              method: :post, remote: not_guest?
    end
  end
end
