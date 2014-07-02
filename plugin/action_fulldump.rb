require "json"

def action_fulldump()
  output = {}
  $storage.list().each do |page|
    output[page.page_title] =
      page.snapshot_list.map do |s|
        {
          "time" => s.time,
          "unixtime" => s.time.to_i,
          "data" => s.data
        }
      end
  end

  return :raw=> output.to_json
end

# vim: sw=2 : ts=1000 :
