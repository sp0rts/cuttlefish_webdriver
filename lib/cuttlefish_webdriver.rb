require "selenium-webdriver"
require 'webdriver-user-agent'

class CuttlefishWebdriver < SimpleDelegator
  def initialize
    chrome_shim_path = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    options = Selenium::WebDriver::Chrome::Options.new

    if chrome_shim_path.nil?
      options.add_argument('--headless')
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-gpu')
      options.add_argument('--remote-debugging-port=9222')
    else
      options.binary = chrome_shim_path
    end

    super Webdriver::UserAgent.driver(
      browser: :chrome,
      agent: :random,
      options: options
    )
  end

  def wait_for(url, seconds)
    get(url)
    Selenium::WebDriver::Wait.new(timeout: seconds).until { yield }
  end
end
