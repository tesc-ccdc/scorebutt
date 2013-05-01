require "scorebutt/version"
require "scorebutt/watcher"
require "scorebutt/host_watcher"

module Scorebutt
  class Scorer

    attr_accessor :sleep_time

    def initialize(attributes)
      self.sleep_time = attributes[:sleep_time]
    end

    def watch(&block)
      watchees = Scorebutt::Watcher.new(&block)
      # Watcher.new should return an array of procs that test each service for a given host
      watcher_blocks = watchees.get_blocks.flatten!
      puts "Got #{watcher_blocks.size} blocks"
      loop do
        watchees.get_blocks.each do |watcher|
          # Watcher is a proc, so run it
          watcher.call
        end
        sleep self.sleep_time
      end
    end

  end
end
