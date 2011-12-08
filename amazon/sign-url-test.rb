#!/usr/bin/env ruby1.9.1
#
# Test for creating signed urls in S3. Allows you to have a url that 
# people can access for a limited period of time.

require 'openssl'
require 'base64'
require 'uri'

ACCESS_KEY="DUMMYDATA" # AWS Access Key
SECRET_KEY="MOREDUMMYDATA" # AWS Secret Key

bucket_name = "example-bucket-name" # bucket the object is in
object = "/example/path/to/object.png" # path to the object - /foo/bar/myobject.png

# When you want your objects to expire
expire_date = Time.now.to_i + 300


# Create the signed string as described at:
# http://docs.amazonwebservices.com/AmazonS3/latest/dev/index.html?RESTAuthentication.html#RESTAuthenticationQueryStringAuth
# http://docs.amazonwebservices.com/AmazonS3/latest/dev/index.html?S3_QSAuth.html
parts = []
parts << "GET"
parts << ""
parts << ""
parts << expire_date
parts << "/#{bucket_name}/#{object}"

string_to_sign = parts.join("\n")

signed_string = Base64.encode64( OpenSSL::HMAC.digest( OpenSSL::Digest::Digest.new('sha1'), SECRET_KEY, string_to_sign)).strip
escaped_string = URI.escape(signed_string, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))

# Final url
url = "http://#{bucket_name}.s3.amazonaws.com/#{object}?AWSAccessKeyId=#{ACCESS_KEY}&Expires=#{expire_date}&Signature=#{escaped_string}"

puts url
