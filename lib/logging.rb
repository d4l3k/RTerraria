class RubycraftLogger
	attr_accessor :log, :tag
	def initialize(tag)
		self.tag = tag
		f = File.open(File.join(File.dirname(__FILE__), "../log.txt"), "a+")
		self.log = Logger.new(
				MultiIO.new(STDOUT, f))
		log.level = Logger::DEBUG
		log.datetime_format = "%Y-%m-%d %H:%M:%S"
		log.formatter = proc { |severity, datetime, progname, msg|
			datetime = datetime.strftime("%Y-%m-%d %H:%M:%S")
			"[#{self.tag}:#{severity}] #{datetime}: #{msg}\n"
		}
		log.info("Logger initialized")
	end
	def debug msg
		self.log.debug msg
	end
	def info msg
		self.log.info msg
	end
	def warn msg
		self.log.warn msg
	end
	def error msg
		self.log.error msg
	end
end
