require('trello').setup({
  api_key = os.getenv("TRELLO_API_KEY"),
  token = os.getenv("TRELLO_TOKEN"),
  bind_keys = true
})
