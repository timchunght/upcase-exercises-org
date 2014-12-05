class PrefixedLogger
  pattr_initialize :logger, :prefix

  def debug(message)
    add :debug, message
  end

  def info(message)
    add :info, message
  end

  def warn(message)
    add :warn, message
  end

  def error(message)
    add :error, message
  end

  def fatal(message)
    add :fatal, message
  end

  private

  def add(level, message)
    logger.send level, "#{prefix}#{message}"
  end
end
