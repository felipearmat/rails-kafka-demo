module Api::V1
  class MessagesController < ApplicationController
    # Listar todos os artigos
    def index
      show
    end
    def show
      message = ReceivedMessage.all
      render json: {message:'Messages loaded', data:message},status: :ok
    end
    def create
      @message = Message.new(message_params)
      if message.save
        # message = {:user => 'banana', :text => 'texto'}
        # $producer.produce(message.to_json, key: message[:user], topic: "messages.publ")
        $producer.produce(message.to_json, key: message[:user], topic: "messages.publ")
        render json: {message:'Saved message', data:message},status: :ok
      else
        render json: {message:'Message not saved', data:message.erros},status: :unprocessable_entity
      end
    end
    private
    def message_params
      params.permit(:user, :text)
    end
  end
end
