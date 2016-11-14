json.array!(@drugs) do |drug|
  json.id  drug.drugID
end
