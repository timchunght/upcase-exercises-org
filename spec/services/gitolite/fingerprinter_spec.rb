require 'spec_helper'

describe Gitolite::Fingerprinter do
  describe '#fingerprint' do
    context 'with a valid key' do
      it 'generates an SSH fingerprint from the data' do
        key =
          'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCbCY06CFBq9fnEC22RgIlrABqRkK' \
          'gmHNcz4+TR3bUfgiyq4exxJBok4K9nTVGHRYtWvH+5NNEL3+b2zr+bARJT57xWGcxF' \
          'bDqCYvKjpAgLFmQGs/Gc2RLmeCPcmqzZC0X0HwhryDr/L0lz9hFYZCoGW8a59dzJCU' \
          'Ke2AeovF455jL/ST9KRjTdpALbMrv6jMgLMuAVuExlxtn9d6WwC+X162WRRTl4tkks' \
          'dRg6GYC9VvsSEf3kHHhKRfwOdDDIIGCjv/Vft9nnFj+v1Ub1tgxJzmMPVJQbchWQLc' \
          '8oams4B3NYtzRx5pyaUSLo0BpYp9RJT4/j8rz7NLtBYBFJ4Icl user@example.com'
        shell = Gitolite::Shell.new
        fingerprinter = Gitolite::Fingerprinter.new(shell)

        fingerprint = fingerprinter.fingerprint(key)

        expect(fingerprint).to eq(<<-FINGERPRINT.strip)
          d4:58:a1:cb:14:94:77:cf:e9:f4:b1:ac:2e:48:05:d2
        FINGERPRINT
      end
    end

    context 'with an invalid key' do
      it 'returns nil' do
        key = 'invalid key'
        shell = Gitolite::Shell.new
        fingerprinter = Gitolite::Fingerprinter.new(shell)

        result = fingerprinter.fingerprint(key)

        expect(result).to be_nil
      end
    end

    context 'with an unparseable fingerprint' do
      it 'returns nil' do
        key = 'invalid key'
        shell = Gitolite::FakeShell.new
        fingerprinter = Gitolite::Fingerprinter.new(shell)

        stub_fingerprint 'unparseable' do
          result = fingerprinter.fingerprint(key)

          expect(result).to be_nil
        end
      end
    end
  end

  def stub_fingerprint(fingerprint)
    Gitolite::FakeShell.with_stubs do |stubs|
      ShellStubber.new(stubs).fingerprint(fingerprint)
      yield
    end
  end
end
