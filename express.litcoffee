#French Press Server

##Dependancies

    fs = require "fs"
    {compile} = require "coffee-script"

    {a,abbr,address,area,article,aside,audio,b,base,bdi,bdo,big,blockquote,body,br,
    button,canvas,caption,cite,code,col,colgroup,data,datalist,dd,del,details,dfn,div,
    dl,dt,em,embed,fieldset,figcaption,figure,footer,form,h1,h2,h3,h4,h5,h6,head,
    header,hr,html,i,iframe,img,input,ins,kbd,keygen,label,legend,li,link,main,map,
    mark,menu,menuitem,meta,meter,nav,noscript,object,ol,optgroup,option,output,p,param,
    pre,progress,q,rp,rt,ruby,s,samp,script,section,select,small,source,span,strong,
    style,sub,summary,sup,table,tbody,td,textarea,tfoot,th,thead,time,title,tr,track,
    u,ul,video,wbr,circle,defs,ellipse,g,line,linearGradient,mask,path,pattern,
    polygon,polyline,radialGradient,rect,stop,svg,tspan,injection, text} = require "./lib/dom"
    makeHTML = require "./lib/makeHTML"

CACHE previously rendered functions.

    CACHE = {}

##Render HTML from FP Element
Renders compressed HTML from an fp template.

**PARAMS**:

+ `path`: The path to the fp template to get HTML for.
+ `locals`: The state bound to the template.

    module.exports = (path, locals, callback)->
        fs.readFile(path, (err, data)->
            if err then throw err
            unless CACHE[path]
                eval "CACHE[path] = function(){#{compile data.toString(), bare: on}};"
            render = CACHE[path].bind(locals)()
            result = "<!DOCTYPE html>"
            result += makeHTML elem for elem in render

            callback null, result
        )