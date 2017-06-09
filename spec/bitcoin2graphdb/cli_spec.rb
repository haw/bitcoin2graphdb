require 'spec_helper'
require 'bitcoin2graphdb/cli'

describe Bitcoin2Graphdb::CLI do

  describe "#start", cli: true do
    it "use -c option, start bitcoin2graphdb deaemon" do
      args = ["start", "-c", "spec/fixtures/default-config.yml"]
      content = capture(:stdout) { Bitcoin2Graphdb::CLI.start(args) }
      expect(content).to match(/Bitcoin2GraphdbDaemon started./m)
    end

    it "use -p or --pid option, create <pidfile>." do
      args = ["start", "-c", "spec/fixtures/default-config.yml"]
      args << "-p"
      args << "foo.pid"
      expect { capture(:stdout) { Bitcoin2Graphdb::CLI.start(args) };sleep 1 }
        .to change {File.exist?("./foo.pid") }.from(false).to(true)
      args = ["start", "-c", "spec/fixtures/default-config.yml"]
      args << "--pid"
      args << "bar.pid"
      expect { capture(:stdout) { Bitcoin2Graphdb::CLI.start(args) };sleep 1 }
        .to change {File.exist?("./bar.pid") }.from(false).to(true)
    end

    it "use -l or --log option, create <logfile>." do
      args = ["start", "-c", "spec/fixtures/default-config.yml"]
      args << "-l"
      args << "foo.log"
      expect { capture(:stdout) { Bitcoin2Graphdb::CLI.start(args) };sleep 1 }
        .to change {File.exist?("./foo.log") }.from(false).to(true)

      args = ["start", "-c", "spec/fixtures/default-config.yml"]
      args << "--log=bar.log"
      expect { capture(:stdout) { Bitcoin2Graphdb::CLI.start(args) };sleep 1 }
        .to change {File.exist?("./bar.log") }.from(false).to(true)
    end
  end

  describe "#stop", cli: true do
    it "-c is not required." do
      args = ["stop", "-c", "spec/fixtures/default-config.yml"]
      content = capture(:stderr) { Bitcoin2Graphdb::CLI.start(args) }
      expect(content).to match(/Usage: "\w+ stop"/m)
    end
  end

end
