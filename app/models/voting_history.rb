class VotingHistory < ActiveRecord::Base
	belongs_to :poll

	scope :has_voted, lambda { |voted|
		where(has_voted: voted)
	}

	validates :encrypted_member_id, :token, :poll_id, presence: true
	validates :encrypted_member_id, uniqueness: {scope: :poll_id}
	validates :has_voted, inclusion: [true, false]

	before_validation :set_token # Sets token that will be used to validate email sent
	after_create			:send_call # Send email calling member to vote

	# Setters for user/member_id
	#   This is just a easy way to save only encrypted ids. Possible methods:
	# 		- user=(User)
	# 		- member=(User)
	# 		- user_id=(id)
	# 		- member_id=(id)
	# 		- encrypted_member_id=(id)
	def user=(user)
		unless user.try(:id).blank?
			self[:encrypted_member_id] = crypter.encrypt_and_sign(user.id)
		else
			self[:encrypted_member_id] = nil
		end
	end

	alias :member= :user=

	def user_id=(id)
		if User.exists?(id)
			self[:encrypted_member_id] = crypter.encrypt_and_sign(id)
		else
			self[:encrypted_member_id] = nil
		end
	end

	alias :member_id= 					:user_id=
	alias :encrypted_member_id= :user_id=

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
	      break token unless VotingHistory.exists?(token: token)
	    end
		end

		def send_call
			user = User.find(self.decrypted_member_id)
			HappyNelMailer.call_to_vote(user.email, self).deliver_now
		end
end
