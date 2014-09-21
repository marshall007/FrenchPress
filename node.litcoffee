#French Press Server

##Dependancies

    DOM = require "./lib/dom"
    makeHTML = require "./lib/makeHTML"


##Render HTML from FP Element
Renders compressed HTML from an fp template.

**PARAMS**:

+ `path`: The path to the fp template to get HTML for.
+ `locals`: The state bound to the template.

    module.exports = (path, locals, callback)->
        callback null, "<!DOCTYPE html>" + makeHTML(require(path).bind(locals, DOM)())