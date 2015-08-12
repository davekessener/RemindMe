#!/bin/env ruby

require 'mysql'
require 'gmail'

class Reminder
	USER = 'reminder'

	def self.remind
		Reminder.with_connection do |c|
			msgs = c.query('SELECT id, recipient, title, message FROM reminders WHERE was_sent != 1 AND send_at <= now()')
			
			Reminder.access_gmail do |gmail|
				msgs.each_hash do |msg|
					begin
						gmail.deliver do
							to msg['recipient']
							subject msg['title']
							text_part { body msg['message'] }
						end
					ensure
						c.query("UPDATE reminders SET was_sent = 1 WHERE id = #{msg['id']}")
					end
				end
			end
		end
	end
	
	def self.access_gmail
			Reminder.with_connection('general') do |c|
				auth = c.query("SELECT * FROM gmail WHERE username = ANY (SELECT email FROM tasks WHERE responsible = '#{USER}')").fetch_hash
				
				Gmail.new(auth['username'], auth['password']) do |gmail|
					yield gmail
				end
			end
	end

	def self.with_connection(db = 'reminder_development')
		c = Mysql.new('localhost', USER, '781227', db)
		begin
			yield c
		ensure
			c.close
		end
	end
end

Reminder.remind
