module Response
  extend ActiveSupport::Concern

  included do
  end

  private

    def api(data, status = :ok, message = nil)
      status_code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]

      message ||= default_messages[status_code]

      payload = {
        response: {
          status: status_code,
          message: message,
          url: request.original_url
        },
        data: data.nil? ? nil : (JSON.parse(data) rescue data)
      }

      render json: JSON.pretty_generate(payload.as_json), status: status
    end

    def default_messages
      {
        200 => "OK",
        201 => "Created",
        202 => "Updated",
        204 => "No Content",
        400 => "Bad Request",
        401 => "Unauthorized",
        403 => "Forbidden",
        404 => "Not Found",
        422 => "Unprocessable Entity",
        500 => "Internal Server Error"
      }
    end
end
