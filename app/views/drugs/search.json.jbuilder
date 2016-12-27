json.array!(@drugs) do |drug|
  json.value     drug.id
  json.label     drug.id + ':' + drug.chiName
end
