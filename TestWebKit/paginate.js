//document.ontouchmove = function(event){event.preventDefault();}

function loadResource(filename, filetype){
    if (filetype=="js"){ //if filename is a external JavaScript file
        var fileref=document.createElement('script')
        fileref.setAttribute("type","text/javascript")
        fileref.setAttribute("src", filename)
    }
    else if (filetype=="css"){ //if filename is an external CSS file
        var fileref=document.createElement("link")
        fileref.setAttribute("rel", "stylesheet")
        fileref.setAttribute("type", "text/css")
        fileref.setAttribute("href", filename)
    }
    if (typeof fileref!="undefined")
        document.getElementsByTagName("head")[0].appendChild(fileref)
}


function paginate(desiredWidth, desiredHeight)
{
    var gap = 10;
    var colsPerPage = 1;
    var bodyID = document.getElementsByTagName('body')[0];
    var totalHeight = bodyID.offsetHeight;
    var columnCount = (Math.floor(totalHeight/desiredHeight) + 1);
    
//    var lastElement;
//    
//    for ( lastElement = bodyID.lastChild; !lastElement.offsetTop; lastElement = lastElement.previousElementSibling );
    
    bodyID.style.paddingBottom = 10; //(optional) prevents clipped letters around the edges
    bodyID.style.width = desiredWidth * columnCount;
    bodyID.style.height = desiredHeight;
    bodyID.style.WebkitColumnCount = columnCount * colsPerPage;
    bodyID.style.WebkitColumnGap = gap;

    return Math.round(bodyID.scrollWidth / bodyID.clientWidth);
//    return Math.round(lastElement.offsetTop / bodyID.clientHeight) / colsPerPage;
}

function scrollToPosition(position)
{
    var prev = document.body.scrollLeft;
    document.body.scrollLeft=position;
    return document.body.scrollLeft != prev;
}

function BMMarker()
{

}
BMMarker.prototype.selectionCoords = function()
{
    var selection = window.getSelection();
    console.log(selection);
    var startNode = this.getXPath(selection.baseNode);
    var endNode = this.getXPath(selection.extentNode);
    console.log(startNode);
    console.log(endNode);
    var cs = this.getCoords(selection.baseNode.parentElement);
    var ce = this.getCoords(selection.extentNode.parentElement);
    console.log(cs);
    console.log(ce);
    
}

BMMarker.prototype.getXPath = function(node, path) 
{
    path = path || [];
    if(node.parentNode) {
        path = this.getXPath(node.parentNode, path);
    }
    
    if(node.previousSibling) {
        var count = 1;
        var sibling = node.previousSibling
        do {
            if(sibling.nodeType == 1 && sibling.nodeName == node.nodeName) {count++;}
            sibling = sibling.previousSibling;
        } while(sibling);
        if(count == 1) {count = null;}
    } else if(node.nextSibling) {
        var sibling = node.nextSibling;
        do {
            if(sibling.nodeType == 1 && sibling.nodeName == node.nodeName) {
                var count = 1;
                sibling = null;
            } else {
                var count = null;
                sibling = sibling.previousSibling;
            }
        } while(sibling);
    }
    
    if(node.nodeType == 1) {
        path.push(node.nodeName.toLowerCase() + (node.id ? "[@id='"+node.id+"']" : count > 0 ? "["+count+"]" : ''));
    }
    return path;
};

BMMarker.prototype.getCoords = function(el) 
{
  
  var _x = 0;
    var _y = 0;
    while( el && !isNaN( el.offsetLeft ) && !isNaN( el.offsetTop ) ) {
        _x += el.offsetLeft - el.scrollLeft;
        _y += el.offsetTop - el.scrollTop;
        el = el.offsetParent;
    }
  
  
  return [_x,_y];
};

var marker = new BMMarker();