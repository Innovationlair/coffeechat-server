prepend_baseurl = (req, attr, object) ->
  baseURL = "#{req.protocol}://#{req.headers.host}/"
  objects = if object instanceof Array then object else [object]
  console.log objects
  for object in objects
    attribute = object[attr]
    if attribute
      object[attr] = "#{baseURL}#{attribute}"
    else
      object[attr] = attribute


module.exports =
  prepend_baseurl: prepend_baseurl
