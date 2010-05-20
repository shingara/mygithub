require 'superfeedr-rb'
Superfeedr::Client.connect(AppConfig.superfeedr['login'], AppConfig.superfeedr['password'], :subscribe_channel => Mygithub::Application::SUBSCRIBE_CHANNEL) do |client|

  # Catch all notifications and check if url has notification and push it
  client.register_handler(:pubsub_event) do |evt|
    status = Superfeedr::Status.parse(evt)
    entries = Superfeedr::Entry.parse(evt)

    if coder = Coder.where(:atom_url => status.feed).limit(1).first
      coder.parse_entries(entries)
    end
    if repo = Repository.where(:atom_url => status.feed).limit(1).first
      repo.parse_entries(entries)
    end
  end

  # automatic reconnection
  client.register_handler(:disconnected) { client.connect }
end

