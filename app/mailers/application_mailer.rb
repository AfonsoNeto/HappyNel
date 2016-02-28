class ApplicationMailer < ActionMailer::Base
  default from: "admin@happy.nel"
  layout 'mailer'

  helper ApplicationHelper
end
