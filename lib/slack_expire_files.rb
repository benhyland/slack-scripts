require 'unirest'

@token = '' # token goes here. DO NOT COMMIT!

@ts_to = (Time.now - 14 * 24 * 60 * 60).to_i

@list_url = 'https://slack.com/api/files.list'
@delete_url = 'https://slack.com/api/files.delete'

def check_response(response)
  if response.code != 200 || !(response.body)
    raise "bad response: #{response.code}\nbody:\n#{response.raw_body}"
  end
  response.body
end

def count_files
  body = list_files(1, 0)['paging']['total']
end

def list_all_files
  count = 1000
  next_page = 1
  files = list_files(next_page, count)['files']
  while files && !files.empty? do
    yield files
    next_page += 1
    files = list_files(next_page, count)['files']
  end
end

def list_files(page, count)
  params = {
    token: @token,
    ts_to: @ts_to,
    page: page,
    count: count
  }
  response = Unirest.get(@list_url, parameters: params)
  check_response response
end

def delete_file(id)
  params = {
    token: @token,
    file: id
  }

  response = Unirest.post(@delete_url, parameters: params)
  check_response response
end

total = count_files
p "Found about #{total} files to delete"

count = 0
list_all_files do |file_batch|
  file_batch.each do |f|
    p "deleting #{f['name']} #{f['id']}..."
    delete_file(f['id'])
    count += 1
  end
end

p "Done: #{count} files deleted"
