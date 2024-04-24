# frozen_string_literal: true

class NotSpecificLocationError < StandardError
  attr_reader :location

  def initialize(location)
    @location = location
  end

  def message
    location.map {|l| l['formatted_address']}.join("\n")
  end
end

