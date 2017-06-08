require 'thor'
require 'base'
require 'json'
require 'yaml'
require 'active_support/all'
require 'daemon_spawn'

module Bitcoin2Graphdb
  class Bitcoin2GraphdbDaemon < DaemonSpawn::Base
    def start(args)
      puts "Bitcoin2GraphdbDaemon start : #{Time.now}"
      migration = Bitcoin2Graphdb::Migration.new(args[0][:bitcoin2graphdb])
      migration.run
    end

    def stop
      puts "Bitcoin2GraphdbDaemon stop : #{Time.now}"
    end

    private
    def config(args)
      config_index = args.index("-c")
    end
  end


  class CLI < Thor
    class_option :pid, aliases: '-p', default: Dir.pwd + '/bitcoin2graphdb.pid', banner: '<pid file path>'
    class_option :log, aliases: '-l', default: Dir.pwd + '/bitcoin2graphdb.log', banner: '<log file path>'
    class_option :conf, aliases: '-c' , required: true, banner: '<configuration file path>'

    desc "start", "start bitcoin2graphdb daemon process"
    def start(name="Ruby")
      conf = if File.exists?(options[:conf])
               YAML.load( File.read(options[:conf]) ).deep_symbolize_keys
             else
               raise ArgumentError.new(
                       "configuration file[#{options[:conf]}] not specified or does not exist.")
             end

      Bitcoin2Graphdb::Bitcoin2GraphdbDaemon.spawn!(
        {
          working_dir: Dir.pwd,
          log_file: File.expand_path(options[:log]),
          pid_file: File.expand_path(options[:pid]),
          sync_log: true,
          singleton: true}, ['start', conf])
    end

    desc "stop", "stop bitcoin2graphdb daemon process"
    def stop
      Bitcoin2Graphdb::Bitcoin2GraphdbDaemon.spawn!(
        {
          working_dir: Dir.pwd,
          log_file: File.expand_path(options[:log]),
          pid_file: File.expand_path(options[:pid]),
          sync_log: true,
          singleton: true}, ['stop'])
    end
  end
end
