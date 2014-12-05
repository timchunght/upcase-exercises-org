server_bin_path = Rails.root.join('server_bin').expand_path.to_s
Cocaine::CommandLine.path = server_bin_path

# The default runner doesn't correctly use the overridden path.
# See https://github.com/thoughtbot/cocaine/issues/63
Cocaine::CommandLine.runner = Cocaine::CommandLine::BackticksRunner.new
