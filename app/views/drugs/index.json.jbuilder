json.array! @json_drugs do |drug|
  json.id drug.drugID
  json.text drug.oriName
end
