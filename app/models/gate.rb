# frozen_string_literal: true

# NOTE: Gate = 改札機のイメージ
class Gate < ApplicationRecord
  FARES = [150, 190].freeze
  MAX_DISTANCE = { FARES[0] => 1, FARES[1] => 2 }.freeze
  validates :name, presence: true, uniqueness: true
  validates :station_number, presence: true, uniqueness: true

  scope :order_by_station_number, -> { order(:station_number) }

  def exit?(ticket)
    entered_station_number = Gate.find(ticket.entered_gate_id).station_number
    moved_distance = (station_number - entered_station_number).abs
    !moved_distance.zero? && MAX_DISTANCE[ticket.fare] >= moved_distance
  end
end
