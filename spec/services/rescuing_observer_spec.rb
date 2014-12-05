require "spec_helper"

describe RescuingObserver do
  describe "#method_missing" do
    context "when no exception is raised" do
      it "delegates and returns nil" do
        observer = double("observer")
        parameter = double("parameter")
        allow(observer).
          to receive(:event_triggered).
          and_return("Observer Return")
        rescuing_observer = build_rescuing_oberver(observer: observer)

        result = rescuing_observer.event_triggered(parameter)

        expect(result).to be_nil
        expect(observer).to have_received(:event_triggered).with(parameter)
      end
    end

    context "when an exception is raised" do
      it "rescues the exception and notifies" do
        observer = double("observer")
        error_notifier = double("error_notifier")
        exception = StandardError.new("Observer Error")
        allow(observer).to receive(:event_triggered).and_raise(exception)
        allow(error_notifier).to receive(:notify)
        rescuing_observer = build_rescuing_oberver(
          observer: observer,
          error_notifier: error_notifier
        )

        rescuing_observer.event_triggered

        expect(error_notifier).to have_received(:notify).with(exception)
      end
    end
  end

  describe "#respond_to?" do
    it "returns true for Object methods" do
      rescuing_observer = build_rescuing_oberver

      expect(rescuing_observer).to respond_to(:inspect)
    end

    it "returns true for observer methods" do
      observer = double("observer")
      allow(observer).to receive(:message)
      rescuing_observer = build_rescuing_oberver(observer: observer)

      expect(rescuing_observer).to respond_to(:message)
    end

    it "returns false for undefined methods" do
      observer = double("observer")
      rescuing_observer = build_rescuing_oberver(observer: observer)

      expect(rescuing_observer).not_to respond_to(:message)
    end
  end

  def build_rescuing_oberver(
    observer: double("observer"),
    error_notifier: double("error_notifier")
  )
    RescuingObserver.new(observer, error_notifier: error_notifier)
  end
end
