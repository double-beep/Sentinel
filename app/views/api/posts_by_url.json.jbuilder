json.items @results.each do |post|
  json.merge! post.as_json
  json.merge!({
    :feedback_counts => @feedback_counts[post.id]
  })
end

json.has_more more_items?(@count, @pagesize, params[:page])
