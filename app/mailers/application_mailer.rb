class ApplicationMailer < ActionMailer::Base
  include MailerHelper
  helper MailerHelper

  default from: "Deepsoul <hola@deepsoul.mx>"
  layout "mailer"
end
