class VotingHistory < ActiveRecord::Base
	belongs_to :poll

	validates :encrypted_member_id, :token, :poll_id, presence: true
	validates :encrypted_member_id, uniqueness: {scope: :poll_id}

	before_validation :set_token

	scope :has_voted, lambda { |voted|
		where(has_voted: voted)
	}

	# Setters for user/member_id
	def user=(user)
		unless user.try(:id).blank?
			self[:encrypted_member_id] = crypter.encrypt_and_sign(user.id)
		else
			self[:encrypted_member_id] = nil
		end
	end

	def user_id=(id)
		if User.exists?(id)
			self[:encrypted_member_id] = crypter.encrypt_and_sign(id)
		else
			self[:encrypted_member_id] = nil
		end
	end

	def decrypted_member_id
		crypter.decrypt_and_verify(self[:encrypted_member_id])
	end

	private
		def crypter
			ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
		end

		def set_token
		  self.token = loop do
	      token = SecureRandom.urlsafe_base64
	      break token unless VotingHistory.where(token: token).exists?
	    end
		end
end
