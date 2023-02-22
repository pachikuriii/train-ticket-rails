# frozen_string_literal: true

# NOTE: Gate = 改札機のイメージ
class Gate < ApplicationRecord
  FARES = [150, 190].freeze
  validates :name, presence: true, uniqueness: true
  validates :station_number, presence: true, uniqueness: true

  scope :order_by_station_number, -> { order(:station_number) }

  def exit?(ticket)
    moved_distance = (station_number - ticket.entered_gate.station_number).abs
    max_distance = FARES.index(ticket.fare) + 1
    !moved_distance.zero? && max_distance >= moved_distance
  end
end
