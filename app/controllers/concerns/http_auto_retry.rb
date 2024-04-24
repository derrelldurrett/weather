# frozen_string_literal: true

require 'net/http'

module HttpAutoRetry
  def get_with_retry(uri, headers = {})
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      request = Net::HTTP::Get.new(uri)
      headers.each { |key, value| request[key] = value }
      return retry_this(http, request)
    end
  end

  private def extract_message(response, body)
    response.message.nil? ? body['error_message'] : response.message
  end

  private def retry_this(http, request)
    retries = 5
    delay = 1
    response = nil
    until retries == 0
      puts request.to_s
      response = http.request(request)
      break if response.code == '200'
      retries -= 1
      sleep delay
    end
    body = JSON.parse(response.body) unless response.nil?
    raise HttpRequestError.new(extract_message(response, body)) if response_error?(response, body)
    body
  end

  private def response_error?(response, body)
    response.nil? or response.code != '200' or body.key?('error_message')
  end
end
