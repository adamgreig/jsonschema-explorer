##############################################################################
# CoffeeScript for jsonschema explorer
# by Adam Greig, March 2012
##############################################################################

##############################################################################
# The few functions we'll need.
##############################################################################

list_manifest = ->
    $('#parent').html "<h1>Loading Manifest...</h1>"
    $.getJSON "schemas/manifest.json", (data) ->
        $('#parent').replaceWith render_manifest data

render_manifest = (data) ->
    node = $ "<section class=property id=parent />"
    node.append "<h1>Available Schemas</h1>"
    for schema in data
        node.append "<a href='#{schema.url}'>#{schema.name}</a><br />"
    return node

load_json_from = (url) ->
    $('#parent').html "<h1>Loading Schema...</h1>"
    location.hash = url
    $.getJSON url, (data) ->
        $('#parent').replaceWith render_object(data).attr 'id', 'parent'

render_object = (data, name) ->
    node = $ "<section class=property />"
    node.append render_attributes data
    node.append $ "<h1>#{data.title or= "Untitled"}</h1>"
    node.append $ "<div class=property-name>#{name}</div>" if name
    node.append $ "<div class=description>#{data.description or= ""}</div>"
    for property of data.properties
        node.append render_object data.properties[property], "\"#{property}\""
    if data.items?
        node.append render_object data.items, "(each item)"
    if data.additionalProperties? and is_object data.additionalProperties
        node.append render_object data.additionalProperties, "(each property)"
    return node

render_attributes = (data) ->
    skipped_attributes = [
        'title', 'description', 'properties', 'items', 'required']
    if is_object data.additionalProperties
        skipped_attributes.push 'additionalProperties'
    attributes = $ "<div class=attributes />"
    attributes.append "<strong>required</strong><br />" if data.required
    for key of data
        continue if key in skipped_attributes
        attributes.append "#{key}: #{data[key]}<br />"
    return attributes

is_object = (obj) ->
    return Object.prototype.toString.call(obj) == '[object Object]'

##############################################################################
# We only need this one binding.
##############################################################################

$(window).bind "hashchange", (event) ->
    load_json_from location.hash.replace /#/, ""

##############################################################################
# Runtime!
##############################################################################

# Set up the body
$("body").append "<section id=parent class=property />"

# Have we been given a hash? Check!
if location.hash
    load_json_from location.hash.replace /#/, ""
else
    list_manifest()
