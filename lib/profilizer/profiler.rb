# frozen_string_literal: true

require 'benchmark'

module Profilizer
  class Profiler
    def profile_method(memory: true, time: true, gc: true)
      profile_memory(!memory) do
        profile_time(!time) do
          profile_gc(!gc) do
            yield
          end
        end
      end
    end

    def profile_memory(skip, &block)
      return block.call if skip

      memory_usage_before = `ps -o rss= -p #{Process.pid}`.to_i
      result = block.call
      memory_usage_after = `ps -o rss= -p #{Process.pid}`.to_i

      used_memory = ((memory_usage_after - memory_usage_before) / 1024.0).round(2)
      puts "Memory usage: #{used_memory} MB"
      result
    end

    def profile_time(skip, &block)
      return block.call if skip

      result = nil

      time_elapsed = Benchmark.realtime do
        result = block.call
      end

      puts "Time: #{time_elapsed.round(2)} seconds"
      result
    end

    def profile_gc(skip, &block)
      return block.call if skip

      GC.start
      before = GC.stat(:total_freed_objects)
      result = block.call
      GC.start
      after = GC.stat(:total_freed_objects)

      puts "Objects Freed: #{after - before}"
      result
    end
  end
end
