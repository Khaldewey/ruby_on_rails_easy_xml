Sidekiq.configure_server do |config|
  config.redis = { 
    url: 'rediss://default:AeoUAAIjcDFhZDkzNjc3N2JjNmQ0ZTFiOTdmODlmYTA5ODUzZjE1N3AxMA@model-tortoise-59924.upstash.io:6379',
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end

Sidekiq.configure_client do |config|
  config.redis = { 
    url: 'rediss://default:AeoUAAIjcDFhZDkzNjc3N2JjNmQ0ZTFiOTdmODlmYTA5ODUzZjE1N3AxMA@model-tortoise-59924.upstash.io:6379',
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end