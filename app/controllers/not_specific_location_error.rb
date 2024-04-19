# frozen_string_literal: true

class NotSpecificLocationError < StandardError
  attr_reader :location
  def initialize(location)
    super
    @location = location
  end

  def message
    m = super.message
    locations = @location.map {}
    [m, locations].join("\n")
  end
end

