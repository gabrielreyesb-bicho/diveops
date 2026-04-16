# frozen_string_literal: true

class BroadcastNewProgramToDiversJob < ApplicationJob
  queue_as :default

  discard_on ActiveJob::DeserializationError

  def perform(program)
    Diver.where(receive_diveops_emails: true).find_each do |diver|
      DiverMailer.new_public_program(diver, program).deliver_later
    end
  end
end
