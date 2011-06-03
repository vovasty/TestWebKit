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
    var bodyID = document.getElementsByTagName('body')[0];
    totalHeight = bodyID.offsetHeight;
    var pageCount = Math.floor(totalHeight/desiredHeight) + 1;
    bodyID.style.paddingBottom = 10; //(optional) prevents clipped letters around the edges
    bodyID.style.width = desiredWidth * pageCount;
    bodyID.style.height = desiredHeight;
    bodyID.style.WebkitColumnCount = pageCount;
    bodyID.style.WebkitColumnGap = 10;
    return Math.floor(bodyID.scrollWidth / bodyID.clientWidth) + 1;
}

function scrollToPosition(position)
{
    var prev = document.body.scrollLeft;
    document.body.scrollLeft=position;
    return document.body.scrollLeft != prev;
}