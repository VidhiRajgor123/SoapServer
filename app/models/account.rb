class Account < ApplicationRecord
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
    validates :mobile_number, presence: true, format: { with: /\A\d{10}\z/ }, length: { is: 10 }, uniqueness: true
end