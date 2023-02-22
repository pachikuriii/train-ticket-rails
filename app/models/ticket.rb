# frozen_string_literal: true

class Ticket < ApplicationRecord
  belongs_to :entered_gate, class_name: 'Gate', foreign_key: 'entered_gate_id'
  belongs_to :exited_gate, class_name: 'Gate', foreign_key: 'exited_gate_id', required: false
  validates :fare, presence: true, inclusion: Gate::FARES
  validates :entered_gate_id, presence: true
  validate :valid_destination?, on: :update

  private

  def valid_destination?
    return if Gate.find(exited_gate_id).exit?(self)

    errors.add(:base, '降車駅 では降車できません。')
  end
end
