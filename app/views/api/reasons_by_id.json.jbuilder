json.items(@results) do |reason|
  json.merge! reason.as_json
  json.merge!({
    :feedback_counts => @feedback_counts
  })
end
json.has_more more?(@count, @pagesize, params[:page])
