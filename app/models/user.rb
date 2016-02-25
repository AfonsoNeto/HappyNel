class User < ActiveRecord::Base
	enum role: [:admin, :member]

	scope :admins, 	-> { where(role: User::roles[:admin])  }
  scope :members, -> { where(role: User::roles[:member]) }

  # Return all users called to vote (even if it has already voted or not) for a given poll
  scope :called_to_vote, lambda { |poll|
  	User.where(id: poll.voting_histories.map {
  		|vh| vh.decrypted_member_id
  	})
  }

  # Return all users that has already voted on a given poll
  scope :has_voted, lambda { |poll|
  	User.where(id: poll.voting_histories.has_voted(true).map {
  		|vh| vh.decrypted_member_id
  	})
  }

  # All users that has not voted yet on a given poll
  scope :not_voted_yet, lambda { |poll| called_to_vote(poll) - has_voted(poll) }

	validates :name, :password, :role, presence: true

	# Devise modules
  devise :database_authenticatable, :registerable, :validatable

  def self.send_call_for_members(poll)
    return false if poll.blank?

    begin
      User.members.find_each do |user|
        VotingHistory.create(user: user, poll: poll, has_voted: false)
      end
    rescue Exception => e
      return false
    end

    return true
  end

  # Overrides devise active_for_authentication to allow only admins to sign in
  def active_for_authentication?
    super and self.admin?
  end
end
