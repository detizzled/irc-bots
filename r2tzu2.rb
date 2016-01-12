require 'cinch'
require 'open-uri'
require 'nokogiri'
require 'cgi'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.freenode.org"
    c.channels = ["#detangled"]
    c.nick = "R2TZU2"
    c.realname = "R2TZU2 0.01 Alpha"
    c.user = "R2TZU2-bot"
  end

  on :message, "hello" do |m|
    m.reply "Hello, #{m.user.nick}"
  end

  on :message, "FUCK!" do |m|
    m.reply "Please settle down, #{m.user.nick}!"
  end

  on :message, "meow" do |m|
    m.reply "Dexter, shall we introduce Wizzy to #{m.user.nick}?"
  end

  on :message, /^!google (.+)/ do |m, query|
    if self.nick == "R2TZU2"
      m.reply google(query)
    end
  end

  on :message, "!op" do |m|
    if m.user.nick == 'dextertzu' || m.user.nick == 'dexter.tzu'
      m.channel.op(m.user)
    end
  end

 helpers do
    # Extremely basic method, grabs the first result returned by Google
    # or "No results found" otherwise
    def google(query)
      url = "http://www.google.com/search?q=#{CGI.escape(query)}"
      res = Nokogiri.parse(open(url).read).at("h3.r")

      title = res.text
      link = res.at('a')[:href]
      desc = res.at("./following::div").children.first.text
    rescue
      "No results found"
    else
      CGI.unescape_html "#{title} - #{desc} (#{link})"
    end
  end

end

bot.start
