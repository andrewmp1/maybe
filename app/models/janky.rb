class Janky < ApplicationRecord
  include Accountable

  class << self
    def color
      "#FF5733" # Choose an appropriate color
    end

    def classification
      "asset"
    end

    def icon
      "zap" # Choose an appropriate Lucide icon
    end

    def display_name
      "Janky"
    end
  end
end
