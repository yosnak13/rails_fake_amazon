class User < ApplicationRecord
  has_many :reviews
  extend display_list
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable
  acts_as_liker

  scope :search_information, -> (keyword) {
    where("name like ?","%#{keyword}%").
    or(where("email like ?","%#{keyword}%")).
    or(where("address like ?","%#{keyword}%")).
    or(where("postal_code like ?","%#{keyword}%")).
    or(where("phone like ?","%#{keyword}%")).
    or(where("id ?","%#{keyword}%"))
  }

  def update_password(params, *options)
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end
end
