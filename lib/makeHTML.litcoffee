#Make HTML
Generates html for given node and it's child nodes.

**PARAMS**:

+ `node`: The node to begin create HTML for. (Renders other nodes recursively)

**RETURNS**: Compressed HTML representation of virtual node and child nodes.

    makeHTML = (node)->
        if node.fp
            {tag, attrs, nodes} = node
            "<#{tag}" + (" #{attr}=\"#{value}\"" for attr, value of attrs).join("") + ">" +
            (makeHTML child for child in node.nodes).join("") +
            "</#{tag}>"
        else "#{node}"

    module.exports = makeHTML