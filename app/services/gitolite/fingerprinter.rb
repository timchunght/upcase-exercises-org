module Gitolite
  class Fingerprinter
    pattr_initialize :shell

    def fingerprint(key)
      with_file_path_containing key do |path|
        path_to_fingerprint path
      end
    end

    private

    def with_file_path_containing(data)
      tempfile = Tempfile.new(['whetstone', '.pub'])
      begin
        tempfile.write(data)
        tempfile.flush
        yield tempfile.path
      ensure
        tempfile.close
        tempfile.unlink
      end
    end

    def path_to_fingerprint(path)
      parse shell.execute("ssh-keygen -lf #{path} || true").strip
    end

    def parse(result)
      match = result.match(/\d{4}\s+([0-9a-f]{2}(?::[0-9a-f]{2}){15})\s/)
      if match
        match[1]
      end
    end
  end
end
