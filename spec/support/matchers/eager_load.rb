module EagerLoadMatcher
  class Matcher
    def initialize(data_creator)
      @data_creator = data_creator
    end

    def matches?(eager_loaded_block)
      @eager_loaded_block = eager_loaded_block

      @output = 3.times.map do
        @data_creator.call
        trace_queries { @eager_loaded_block.call }
      end

      @output.second.size == @output.third.size
    end

    def supports_block_expectations?
      true
    end

    def failure_message
      'Expected block to be eager loaded, but received extra queries. ' \
        "Queries:\n#{@output.third.join("\n")}"
    end

    private

    def trace_queries(&block)
      output = StringIO.new
      logger = ActiveSupport::Logger.new(output)
      with_logger(logger, &block)
      output.rewind
      output.read.split("\n")
    end

    def with_logger(logger)
      old_logger = ActiveRecord::Base.logger
      ActiveRecord::Base.logger = logger
      yield
    ensure
      ActiveRecord::Base.logger = old_logger
    end
  end

  # Verifies that the subject block performs a constant number of queries when
  # loading data created by the given block.
  #
  # @example
  #   expect { User.with_posts }.to eager_load { create(:post) }
  def eager_load(&data_creator)
    Matcher.new(data_creator)
  end
end

RSpec.configure do |config|
  config.include EagerLoadMatcher, type: :model
end
