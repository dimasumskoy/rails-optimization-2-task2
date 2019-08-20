# frozen_string_literal: true

require 'json'
require 'pry'
require 'date'
require 'set'

require 'ruby-progressbar'
require 'ruby-prof'

require_relative 'user'

class Work
  SUPPORT = {
    user: 'user',
    session: 'session',
    semicolon: ',',
    line_feed: "\n",
    empty_string: '',
    browsers: {
      ie: 'INTERNET EXPLORER',
      chrome: 'CHROME'
    }
  }.freeze

  UNIQUE_BROWSERS = Set.new

  def initialize(file: nil)
    @file          = file
    @sessions      = []
    @users_objects = []
    @report        = {}

    @report[:totalUsers] ||= 0
    @report[:uniqueBrowsersCount] ||= 0
    @report[:totalSessions] ||= 0
  end

  def perform
    return unless @file

    File.readlines(@file).each do |line|
      fields = line.tr!(SUPPORT[:line_feed], SUPPORT[:empty_string]).split(SUPPORT[:semicolon])
      object = fields[0]

      if object == SUPPORT[:user]
        @user = User.new(attributes: parse_user(fields))
        @users_objects << @user

        @report[:totalUsers] += 1
      elsif object == SUPPORT[:session]
        @session = parse_session(fields)

        unless UNIQUE_BROWSERS.include?(@session[:browser])
          UNIQUE_BROWSERS << @session[:browser]
          @report[:uniqueBrowsersCount] += 1
        end

        @user.sessions << @session if @session[:user_id] == @user.id
        @sessions << @session

        @report[:totalSessions] += 1
      end
    end

    @report[:allBrowsers] = @sessions.map { |s| s[:browser].upcase }.sort.uniq.join(',')
    @report[:usersStats]  = {}

    @users_objects.each do |user|
      user_key    = "#{user.attributes[:first_name]} #{user.attributes[:last_name] }"
      users_stats = @report[:usersStats][user_key] || {}

      browsers           = user.sessions.map { |s| s[:browser].upcase }
      browsers_string    = browsers.sort.join(', ')
      user_sessions_time = user.sessions.map { |s| s[:time].to_i }

      @report[:usersStats][user_key] = users_stats.merge(
        sessionsCount: user.sessions.count,
        totalTime: "#{user_sessions_time.sum} min.",
        longestSession: "#{user_sessions_time.max} min.",
        browsers: browsers_string,
        usedIE: browsers.any? { |b| b.include?(SUPPORT[:browsers][:ie]) },
        alwaysUsedChrome: browsers.all? { |b| b.include?(SUPPORT[:browsers][:chrome]) },
        dates: user.sessions.map { |s| s[:date] }.sort.reverse
      )
    end

    # GC.start(full_mark: true, immediate_sweep: true)
    File.write('result.json', "#{@report.to_json}\n")
  end

  private

  def parse_user(fields)
    {
      id: fields[1].to_i,
      first_name: fields[2],
      last_name: fields[3],
      age: fields[4].to_i,
      sessions: []
    }
  end

  def parse_session(fields)
    {
      user_id: fields[1].to_i,
      session_id: fields[2].to_i,
      browser: fields[3],
      time: fields[4],
      date: fields[5]
    }
  end
end
