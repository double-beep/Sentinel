class Feedback < ApplicationRecord
  belongs_to :post
  belongs_to :feedback_type

  validates :feedback_type, presence: true
  validates :post, presence: true

  after_create do
    Rails.cache.delete("post_#{post.id}_majority_feedback")
    Feedback.where(chat_id: chat_id, post_id: post_id).where.not(id: id).destroy_all
  end
end
