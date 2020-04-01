# frozen_string_literal: true

require 'logger'

# common utils
module Utils
  def log
    @log ||= Logger.new(STDOUT)
    @log
  end
end
