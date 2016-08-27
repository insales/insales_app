module Api::V1
  class ApiController < ActionController::Base
    before_action :add_allow_credentials_headers

    def add_allow_credentials_headers
      # https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS#section_5
      # Because we want our front-end to send cookies to allow the API to be authenticated
      # (using 'withCredentials' in the XMLHttpRequest), we need to add some headers so
      # the browser will not reject the response
      response.headers['Access-Control-Allow-Origin'] = request.headers['Origin'] || '*'
      response.headers['Access-Control-Allow-Credentials'] = 'true'
    end
  end
end
