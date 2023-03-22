class ApplicationController < ActionController::API
  # to encode our token
  def encode_token(payload)
    JWT.encode(payload, "secret")
  end
  # to decode our token
  def decode_token
    #get the token from the headers
    auth_header = request.headers['Authorization']
    #check whether the token is present
    if auth_header
      # 'Bearer hafsgakdnsj' split(' ')[1] is splitting the token
      token = auth_header.split(' ')[1]
      # wrap the decoding process within an exception
      begin
        JWT.decode(token, 'secret', true, algorithm: HS256)
      rescue JWT::DecodeError
        nil
      end
    end
  end
  # allow user to access app content
  def authorised_user
    #use the decode_token method to get user details
    decoded_token = decode_token()

    if decoded_token
      #take out the user by id
      user_id = decoded_token[0]['id']
        # [{payload},{header},{verify_signature}]
        # {
        #   "id":10,
        #   "firstname": "John"
        # }

        #find the user that matches the ID
      user = User.find_by(id: user_id)
    else
      render json {error: 'user not found'}, status: :not_found
    end

  end

  #return response to the user on being authorized
  def authorize
    render json {error: 'user not authorized'}, status: :unauthorized unless authorize_user

  end
end
