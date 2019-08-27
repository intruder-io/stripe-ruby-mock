module StripeMock
  module RequestHandlers
    module SetupIntents

      def SetupIntents.included(klass)
        klass.add_handler 'post /v1/setup_intents',                 :new_setup_intent
        klass.add_handler 'post /v1/setup_intents/([^/]*)',         :update_setup_intent
        klass.add_handler 'get /v1/setup_intents/([^/]*)',          :get_setup_intent
        klass.add_handler 'post /v1/setup_intents/(.*)/confirm',    :confirm_setup_intent
        klass.add_handler 'post /v1/setup_intents/(.*)/cancel',     :cancel_setup_intent
        klass.add_handler 'get /v1/setup_intents',                  :list_setup_intents
      end

      def new_setup_intent(route, method_url, params, headers)
        id = new_id('seti')

        setup_intents[id] = Data.mock_setup_intent(
          params.merge(
            id: id,
          )
        )

        setup_intents[id].clone
      end

      def update_setup_intent(route, method_url, params, headers)
        # TODO
      end

      def get_setup_intent(route, method_url, params, headers)
        route =~ method_url
        setup_intent_id = $1 || params[:setup_intent]
        setup_intent = assert_existence :setup_intent, setup_intent_id, setup_intents[setup_intent_id]

        setup_intent = setup_intent.clone
        setup_intent
      end

      def confirm_setup_intent
        # TODO
      end

      def cancel_setup_intent
        # TODO
      end

      def list_setup_intents(route, method_url, params, headers)
        params[:offset] ||= 0
        params[:limit] ||= 10

        clone = setup_intents.clone

        if params[:customer]
          clone.delete_if { |k,v| v[:customer] != params[:customer] }
        end

        Data.mock_list_object(clone.values, params)
      end

      private

    end
  end
end
