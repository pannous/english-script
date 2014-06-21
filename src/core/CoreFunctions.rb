module CoreFunctions
  #class CoreFunctions
  def show node
    puts node.to_s
  end

  def download url
    require 'net/http'
    require 'uri'
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = url =~ /https/
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    #response.status
    #response["header-here"] # All headers are lowercase
    response.body
  end


end
