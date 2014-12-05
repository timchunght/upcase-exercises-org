require 'spec_helper'

describe Git::BackgroundServer do
  %w(find_clone find_source).each do |method_name|
    describe "##{method_name}" do
      it 'delegates and returns immediately' do
        expected_result = double('expected_result')
        job_factory = double('job_factory')
        args = %w(one two)
        server = double('server')
        allow(server).
          to receive(method_name).
          with(*args).
          and_return(expected_result)
        background_server = Git::BackgroundServer.new(server, job_factory)

        result = background_server.send(method_name, *args)

        expect(result).to eq(expected_result)
      end
    end
  end

  %w(add_key create_clone create_exercise fetch_diff).each do |method_name|
    describe "##{method_name}" do
      it 'creates a background job to delegate' do
        args = %w(one two)
        server = double('server')
        job_factory = double('job_factory')
        allow(job_factory).to receive(:new)
        background_server = Git::BackgroundServer.new(server, job_factory)

        result = background_server.send(method_name, *args)

        expect(result).to be_nil
        expect(job_factory).to have_received(:new).
          with(method_name: method_name, data: args)
      end
    end
  end
end
