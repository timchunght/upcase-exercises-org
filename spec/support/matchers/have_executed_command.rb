RSpec::Matchers.define :have_executed_commands do |*expected_commands|
  match do |shell|
    check_commands shell.commands, expected_commands
  end

  failure_message do |shell|
    "Expected shell to execute #{inspect_commands(expected_commands)}\n\n" \
      "But got #{inspect_commands(shell.commands)}"
  end

  def check_commands(actual, expected)
    case expected
    when []
      true
    else
      command, *expected_remaining = expected
      if index = actual.index(command)
        actual_remaining = actual.slice(index, actual.length)
        check_commands(actual_remaining, expected_remaining)
      else
        false
      end
    end
  end

  def inspect_commands(commands)
    if commands.any?
      "commands:\n" +
        commands.map { |command| "  #{command}" }.join("\n")
    else
      'no commands'
    end
  end
end

module HaveExecutedCommand
  def have_executed_command(command)
    have_executed_commands(command)
  end
end

RSpec.configure do |config|
  config.include HaveExecutedCommand
end
