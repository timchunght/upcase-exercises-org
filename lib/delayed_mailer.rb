# Decorates an ActionMailer::Base class to deliver messages in a background job.
class DelayedMailer
  pattr_initialize :mailer

  def method_missing(method_name, *args)
    if mailer.respond_to?(method_name)
      Message.new(mailer, method_name, args)
    else
      super
    end
  end

  def respond_to_missing?(*args)
    mailer.respond_to?(*args)
  end

  class Message
    pattr_initialize :mailer, :method_name, :args

    def deliver
      mailer.delay.send(method_name, *args)
    end
  end

  private_constant :Message
end
