require 'net/http'
require 'pathname'

# Copyright (c) 2008 Caio Chassot
# with parts from Exception Notifier plugin, Copyright (c) 2005 Jamis Buck
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module RailzScout
  extend self
  
  mattr_accessor :config
  @@config = {
    :url       => nil,
    :username  => 'RailzScout',
    :project   => 'Inbox',
    :area      => 'Misc',
    :title     => nil,
    :body      => nil,
    :email     => nil,
    :force_new => false,
  }
  
  mattr_accessor :sections
  @@sections = %w[ request session environment backtrace ]

  def create_bug_form_data(bug_params)
    bug = config.merge(bug_params)
    { :ScoutUserName    => bug[:username],
      :ScoutProject     => bug[:project],
      :ScoutArea        => bug[:area],
      :Description      => bug[:title],
      :Extra            => bug[:body],
      :Email            => bug[:email],
      :ForceNewBug      => (bug[:force_new] ? 1 : 0),
      :FriendlyResponse => 0, # 1 to response in HTML, 0 as XML
    }
  end
  
  def submit_bug(exception, controller, request, data={})
    bug_params = {}
    bug_params[:title] = "#{controller.controller_name}##{controller.action_name} (#{exception.class}) #{exception.message.inspect}"
    bug_params[:body]  = render(data.merge({
      :rails_root => rails_root, 
      :controller => controller, 
      :host       => request.env["HTTP_HOST"],
      :request    => request,
      :exception  => exception, 
      :backtrace  => sanitize_backtrace(exception.backtrace),
      :data       => data,
      :sections   => sections }))
    
    response = Net::HTTP.post_form(URI.parse(config[:url]), create_bug_form_data(bug_params))
    raise "RailzScout post to FogBugz failed." unless response.body =~ /<Success>/
  end
  
  def render(assigns)
    view_path = Pathname.new("#{File.dirname(__FILE__)}/../views").cleanpath.to_s
    ActionView::TemplateFinder.process_view_paths(view_path)
    view = ActionView::Base.new([view_path], assigns, self)
    view.extend ExceptionNotifierHelper
    view.render "exception_notifier/exception_notification"
  end
  
  def controller_name; "exception_notifier" end
  alias_method :controller_path, :controller_name
  def self.logger; RAILS_DEFAULT_LOGGER end
  
  private

  def sanitize_backtrace(trace)
    re = Regexp.new(/^#{Regexp.escape(rails_root)}/)
    trace.map { |line| Pathname.new(line.gsub(re, "[RAILS_ROOT]")).cleanpath.to_s }
  end

  def rails_root
    @rails_root ||= Pathname.new(RAILS_ROOT).cleanpath.to_s
  end

end
