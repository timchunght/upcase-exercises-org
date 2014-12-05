module BackgroundJobs
  def run_background_jobs_immediately
    delay_jobs = Delayed::Worker.delay_jobs
    Delayed::Worker.delay_jobs = false
    yield
  ensure
    Delayed::Worker.delay_jobs = delay_jobs
  end

  def pause_background_jobs
    delay_jobs = Delayed::Worker.delay_jobs
    Delayed::Worker.delay_jobs = true
    yield

    unless delay_jobs
      Delayed::Worker.new.work_off
    end
  ensure
    Delayed::Worker.delay_jobs = delay_jobs
  end

  module_function :pause_background_jobs
end

RSpec.configure do |config|
  config.around(:each, type: :feature) do |example|
    run_background_jobs_immediately do
      example.run
    end
  end

  config.include BackgroundJobs
end
