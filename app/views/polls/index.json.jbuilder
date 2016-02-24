json.array!(@polls) do |poll|
  json.extract! poll, :id, :acumulated_score, :final_result
  json.url poll_url(poll, format: :json)
end
