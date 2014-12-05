module Gitolite
  # Writes a full Gitolite configuration into the current directory based on
  # application state.
  class ConfigWriter
    include ::NewRelic::Agent::MethodTracer

    CONFIG_FILE_PATH = 'conf/gitolite.conf'.freeze
    KEYDIR_PATH = 'keydir'.freeze
    SERVER_USERNAME = 'server'.freeze
    TEMPLATE_PATH =
      Rails.root.join('app', 'views', 'gitolite_config', 'gitolite.conf.erb')

    pattr_initialize [:public_keys!, :server_key!, :sources!]

    def write
      write_config_file
      rewrite_key_directory
    end

    private

    def write_config_file
      open_config_file do |file|
        file.puts evaluate_template
      end
    end

    def open_config_file(&block)
      File.open(CONFIG_FILE_PATH, 'w', &block)
    end

    def evaluate_template
      ERB.new(template_contents).result(binding).strip
    end

    def template_contents
      IO.read(TEMPLATE_PATH)
    end

    def admin_usernames
      [SERVER_USERNAME] + ::User.admin_usernames
    end

    def usernames
      ::User.by_username.map(&:username).compact
    end

    def rewrite_key_directory
      clean_key_directory
      write_staging_key
      write_user_keys
    end

    def clean_key_directory
      FileUtils.rm_rf(KEYDIR_PATH)
    end

    def write_staging_key
      write_key "#{KEYDIR_PATH}/#{SERVER_USERNAME}.pub", server_key
    end

    def write_user_keys
      ::User.by_username.each do |user|
        write_keys_for user.username, public_keys.for(user)
      end
    end

    def write_keys_for(username, public_keys)
      public_keys.each do |public_key|
        write_key(
          "#{KEYDIR_PATH}/#{public_key.id}/#{username}.pub",
          public_key.data
        )
      end
    end

    def write_key(path, data)
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') { |file| file.puts(data) }
    end

    add_method_tracer :write_config_file
    add_method_tracer :rewrite_key_directory
  end
end
